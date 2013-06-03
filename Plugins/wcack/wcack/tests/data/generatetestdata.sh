#!/bin/sh

# This would be better served if ack worked as a subprocess of a shell script, but it doesn't

# "ei.*?od" 
# ack -l -1 "ei.*?od" testfile.txt : return filename
# ack -h -o -1 "ei.*?od" testfile.txt  : returns just the match
# ack -H -o -1 "ei.*?od" testfile.txt : As close as I can get to the line number

# Add an option either to print to stdout or write to file



SEARCH_TERM="ei.*?od"
OUTPUT_YAML_FILE="test_data_generated.yml"
OUTPUT_INPUT_FILE="test_data_input_file"
TEST_FILES=(testfile.txt testfile2.txt)

exec > $OUTPUT_YAML_FILE

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