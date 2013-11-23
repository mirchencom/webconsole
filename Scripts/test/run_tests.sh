#!/bin/sh

usage () {
	echo "Usage: run_tests.sh [-l]"
	echo
	echo "-l : Run long tests"
	echo "-c : Run only XCUnit tests"
}

LONG=false
XCUNIT=false
while getopts lch option
do
	case "$option"
	in
	    l)  LONG=true
			;;
	    c)  XCUNIT=true
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

if $XCUNIT ; then
	rake xcunit
	exit 0
fi

if $LONG ; then
	rake long
	exit 0
fi

rake