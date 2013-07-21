#!/bin/sh

if [[ -z "$PLUGIN_DIRECTORY" ]]; then
	SCRIPT=./wcirb.rb
else
	SCRIPT="$PLUGIN_DIRECTORY/wcirb/wcirb.rb"
fi

irb | "$SCRIPT"