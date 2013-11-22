#!/bin/sh

usage () {
	echo "Usage: run_tests.sh [-l]"
	echo
	echo "-l : Run long tests"
}

LONG=false
while getopts lh option
do
	case "$option"
	in
	    l)  LONG=true
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

if $LONG ; then
	rake long
else
	rake
fi