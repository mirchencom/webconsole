#!/bin/sh

SCRIPT_DIRECTORY=`dirname $0`

ack --color $1 | $SCRIPT_DIRECTORY/wcack.rb