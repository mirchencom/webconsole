#!/usr/bin/env ruby

require "test/unit"

SCRIPT_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, 'lib', 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_DATA_PARSER_FILE
require TEST_PARSER_ADDITIONS_FILE
require PARSER_FILE

class TestParser < Test::Unit::TestCase

  def test_parser
    test_ack_output = TestHelper::TestData::test_ack_output
    test_data_directory = TestHelper::TestData::test_data_directory
    
    parser = WcAck::Parser.new(nil, test_data_directory)
    # parser = WcAck::Parser.new(nil)
    parser.parse(test_ack_output)
    files_hash = parser.files_hash

    test_data_json = TestHelper::TestData::test_data_json
    test_files_hash = TestHelper::Parser::parse(test_data_json)

    test_files_hash.keys.each do |file_path|
      test_file = test_files_hash[file_path]
      file = files_hash[file_path]
      
      assert_equal(test_file.file_path, file.file_path, "The test file path should equal the file path.")
      assert_equal(test_file.display_file_path, file.display_file_path, "The test display file path should equal the display file path.")

      test_file.lines.zip(file.lines).each do |test_line, line|
        assert_equal(test_line.number, line.number, "The test line number should equal the line number.")
        assert_equal(test_line.matches.count, line.matches.count, "The test line match count should equal the line match count.")

        test_line.matches.zip(line.matches).each do |test_match, match|
          assert_equal(test_match.text, match.text, "The test match text should equal the match text.")
        end
      end
    end
  end

end

