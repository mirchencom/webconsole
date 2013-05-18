require File.join(File.dirname(__FILE__), 'lib', 'importer')
require File.join(File.dirname(__FILE__), 'lib', 'template')

# puts file_hash.inspect

# Take the hash and construct classes from it

# file[0].line[1].match[1].start

# YML_FILE="./support/test_data.yml"
YML_FILE=File.join(File.dirname(__FILE__), 'support', 'test_data.yml')


files = WcAck::import_yml(YML_FILE)

# WcAck::dump_files(files)

WcAck::render_files(files)