#!/bin/sh

# This would be better served if ack worked as a subprocess of a shell script, but it doesn't

# "ei.*?od" 
# ack -l -1 "ei.*?od" testfile.txt : return filename
# ack -h -o -1 "ei.*?od" testfile.txt  : returns just the match
# ack -H -o -1 "ei.*?od" testfile.txt : As close as I can get to the line number

SEARCH_TERM="ei.*?od"
OUTPUT_YAML_FILE="test_data_generated.yml"
OUTPUT_DATA_FILE="line_output_file"
TEST_FILES=(testfile.txt testfile2.txt)

function GENERATE_TEST_DATA () {
	TERM=$1
	TEST_FILE=$2

	FILE_PATH=`ack --files-with-matches $TERM $TEST_FILE`

	echo $FILE_PATH
	TEXT_MATCHES=(`ack --no-filename -o $TERM $thisTEST_FILE`)
ack --with-filename --noheading --nocolor -o 	

	
	for thisTEXT_MATCH in ${TEXT_MATCHES[*]}; do
		LINE_NUMBER=`ack --with-filename -o -1 $TERM $TESTFILE`
		LINENUMBER=`echo $LINENUMBER | sed -n 's/.*:\(.*\):.*/\1/p'`

		# echo $thisTEXT_MATCH
	done
}


for thisTEST_FILE in ${TEST_FILES[*]}; do
	GENERATE_TEST_DATA "$SEARCH_TERM" "$thisTEST_FILE"
done

exit 0



# Per match

# Convert this to parsing each line of output



ack --with-filename -o "ei.*?od" "testfile.txt"

# ack --with-filename --noheading --nocolor -o "ei.*?od" testfile.txt testfile2.txt

# Output the line to separate file because 
ack --color --with-filename -1 $TERM $TESTFILE > $LINEOUTPUTFILE

cat <<EOF > $OUTPUTFILE
test_data:
  line_output_file: $LINEOUTPUTFILE
  search_term: $TERM
result_data:
  file_path: $FILEPATH
  matched_text: $MATCHEDTEXT
  line_number: $LINENUMBER
EOF