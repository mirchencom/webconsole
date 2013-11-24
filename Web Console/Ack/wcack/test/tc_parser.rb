#!/usr/bin/env ruby

require "test/unit"

SCRIPT_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_PARSER_ADDITIONS_FILE
require PARSER_FILE

class TestParser < Test::Unit::TestCase

  def test_parser
    test_data_helper = TestDataHelper.new
    test_data = test_data_helper.test_data

    parser = WcAck::Parser.new
    parser.parse(test_data)

    files_hash = parser.files_hash
    test_files_hash = test_data_helper.test_files_hash

    test_files_hash.keys.each do |file_path|
      test_file = test_files_hash[file_path]
      file = files_hash[file_path]
      
      test_file.lines.zip(file.lines).each do |test_line, line|
        assert_equal(test_line.number, line.number, "Line numbers don't match.")
        assert_equal(test_line.matches.count, line.matches.count, "Match counts don't match")
        test_line.matches.zip(line.matches).each do |test_match, match|
          assert_equal(test_match.text, match.text, "Matched text doesn't match")
        end
      end
    end
  end

end

