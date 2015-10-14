#!/bin/sh

usage () {
	echo "Usage: run_tests.sh [-lrc]"
	echo
	echo "Default is Xcode tests and ruby tests"
	echo "-l : Also run long tests"
	echo "-r : Run only ruby tests"
	echo "-x : Run only Xcode tests"
}

LONG=false
XCUNIT=false
RUBY=false
while getopts lxrh option
do
	case "$option"
	in
	    l)  LONG=true
			;;
	    x)  XCUNIT=true
			;;
	    r)  RUBY=true
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

if $RUBY ; then
	rake ruby
	exit 0
fi

rake