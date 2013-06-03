#!/bin/bash

SEARCH_TERM="ei.*?od"
OUTPUT_YAML_FILE="test_data_generated.yml"
OUTPUT_INPUT_FILE="test_data_input_file"
TEST_FILES=(testfile.txt testfile2.txt)

usage () {
	echo "Usage: generatetestdata [-v]"
}

VERBOSE=false
while getopts vh option; do
	case "$option" in
	    v)  VERBOSE=true
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

if $VERBOSE; then
	exec > >(tee $OUTPUT_YAML_FILE)
else
	exec > $OUTPUT_YAML_FILE
fi

ack --color --with-filename $SEARCH_TERM ${TEST_FILES[@]} > $OUTPUT_INPUT_FILE
echo "input_file: $OUTPUT_INPUT_FILE"
echo "results:"

function GENERATE_TEST_DATA () {
	TERM=$1
	TEST_FILE=$2

	FILE_PATH=`ack --files-with-matches $TERM $TEST_FILE`


	LINE_MATCHES=(`ack --with-filename --noheading --nocolor -o $TERM $thisTEST_FILE`)
	
	for thisLINE_MATCH in ${LINE_MATCHES[*]}; do
		LINE_NUMBER=`echo $thisLINE_MATCH | sed -n 's/.*:\(.*\):.*/\1/p'`


		MATCHED_TEXT=`echo $thisLINE_MATCH | sed -n 's/.*:.*:\(.*\)/\1/p'`

		echo "    - file_path: $FILE_PATH"
		echo "      line_number:  $LINE_NUMBER"
		echo "      matched_text: $MATCHED_TEXT"
	done
}

for thisTEST_FILE in ${TEST_FILES[*]}; do
	GENERATE_TEST_DATA "$SEARCH_TERM" "$thisTEST_FILE"
done