#!/bin/sh

# SCRIPT_DIRECTORY=`dirname $0`

# SCRIPT_PATH=$(readlink -f $0)
# SCRIPT_DIRECTORY=$(dirname $SCRIPT)

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# echo "SCRIPT_DIRECTORY = $SCRIPT_DIRECTORY"

ack --color $1 | "$SCRIPT_DIRECTORY/wcack.rb"