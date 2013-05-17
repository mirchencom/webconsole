#!/bin/sh

TESTDIRECTORY="/Users/robenkleene/Dropbox/Text"
SEARCHTERM="data"

usage () {
	echo "Usage: testcommand.sh [-rch]"	
	echo "-c: Color"
	echo "-r: Run through parser"
	echo "-s: Small output"
	echo "-g: Generate output, same input that goes to the parser as run"
}

RUN=false
COLOR=false
SMALL=false
while getopts srchg option; do
	case "$option" in
		c) 	COLOR=true
			;;
	    r)	RUN=true
			;;
	    s)	SMALL=true
			;;
		g)	GENERATE=true
			;;
	    h)  usage
	        exit 0 
	        ;;
	    \?) echo "Invalid option or missing argument"
			usage
	        exit 1
	        ;;
	esac
done

COMMAND="ack --color"

if $GENERATE; then
	$COMMAND $SEARCHTERM $TESTDIRECTORY
	exit 0
fi

if $RUN; then
	$COMMAND $SEARCHTERM $TESTDIRECTORY | ./wcack.rb
	exit 0
fi

COMMAND="ack"

if $COLOR; then
	COMMAND="$COMMAND --color"
else
	COMMAND="$COMMAND --nocolor"
fi

if $SMALL; then
	$COMMAND $SEARCHTERM $TESTDIRECTORY | head -n 10
else 
	$COMMAND $SEARCHTERM $TESTDIRECTORY
fi