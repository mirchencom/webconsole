#!/usr/bin/env ruby

require 'Shellwords'

TEST_LIB_DIRECTORY = File.join(File.dirname(__FILE__), "..", 'lib')
TEST_SCRIPT_CONSTANTS_FILE = File.join(TEST_LIB_DIRECTORY, 'test_script_constants')
require TEST_SCRIPT_CONSTANTS_FILE

command = "ack --color --with-filename \"#{SEARCH_TERM}\" #{Shellwords.escape(TEST_DATA_DIRECTORY)}"
result = `#{command}`
puts result