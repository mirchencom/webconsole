#!/usr/bin/env ruby

require 'json'
require 'Shellwords'
require 'pathname'

SCRIPT_DIRECTORY = File.dirname(__FILE__)
TEST_LIB_DIRECTORY = File.join(SCRIPT_DIRECTORY, "..", 'lib')
TEST_SCRIPT_CONSTANTS_FILE = File.join(TEST_LIB_DIRECTORY, 'test_script_constants')
require TEST_SCRIPT_CONSTANTS_FILE
TEST_DATA_CONSTANTS_FILE = File.join(TEST_LIB_DIRECTORY, 'test_data_constants')
require TEST_DATA_CONSTANTS_FILE

matches = []
Dir.foreach(TEST_DATA_DIRECTORY) do |filename|
  next if filename == '.' or filename == '..'

  file_path = File.join(TEST_DATA_DIRECTORY, filename)

  command = "ack --with-filename --noheading --nocolor -o \"#{SEARCH_TERM}\" #{Shellwords.escape(file_path)}"
  match_lines = `#{command}`
  match_lines.each_line do |line_match|
    match_hash = Hash.new

    line_number = /.*:(.*):.*/.match(line_match).captures[0]
    matched_text = /.*:.*:(.*)/.match(line_match).captures[0]

    match_hash[FILE_PATH_KEY] = File.expand_path(file_path)
    match_hash[DISPLAY_FILE_PATH_KEY] = Pathname.new(file_path).relative_path_from(Pathname.new(TEST_DATA_DIRECTORY)).to_s
    match_hash[LINE_NUMBER_KEY] = line_number
    match_hash[MATCHED_TEXT_KEY] = matched_text
    matches << match_hash
  end
end

puts matches.to_json