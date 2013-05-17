#!/bin/sh

# This would be better served if ack worked as a subprocess of a shell script, but it doesn't

# "ei.*?od" 
# ack -l -1 "ei.*?od" testfile.txt : return filename
# ack -h -o -1 "ei.*?od" testfile.txt  : returns just the match
# ack -H -o -1 "ei.*?od" testfile.txt : As close as I can get to the line number

TERM="ei.*?od"
TESTFILE="testfile.txt"
OUTPUTFILE="test_data_generated.yml"

FILENAME=`ack -l -1 $TERM $TESTFILE`
MATCH=`ack -h -o -1 "ei.*?od" testfile.txt`

LINENUMBER=`ack -H -o -1 "ei.*?od" testfile.txt`
LINENUMBER=`echo $LINENUMBER | sed -n 's/.*:\(.*\):.*/\1/p'`

LINE=`ack --color -H -1 "ei.*?od" testfile.txt`

cat <<EOF > $OUTPUTFILE
test:
  line: $LINE
  term: $TERM
result:
  filename: $FILENAME
  match: $MATCH
  linenumber: $LINENUMBER
EOF