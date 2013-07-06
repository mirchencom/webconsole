#!/bin/sh

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ack --color $1 `pwd` | "$SCRIPT_DIRECTORY/wcack.rb"