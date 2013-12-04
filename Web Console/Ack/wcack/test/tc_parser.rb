#!/usr/bin/env ruby

require "test/unit"

SCRIPT_DIRECTORY = File.dirname(__FILE__)
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, 'lib', 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_DATA_PARSER_FILE
require TEST_PARSER_ADDITIONS_FILE
require TEST_DATA_TESTER_FILE
require PARSER_FILE

class TestParser < Test::Unit::TestCase

  def test_parser
    test_ack_output = TestHelper::TestData::test_ack_output
    test_data_directory = TestHelper::TestData::test_data_directory
    
    parser = WcAck::Parser.new(nil, test_data_directory)
    parser.parse(test_ack_output)
    files_hash = parser.files_hash

    test_data_json = TestHelper::TestData::test_data_json
    test_files_hash = TestHelper::Parser::parse(test_data_json)

    file_hashes_match = TestHelper::TestDataTester::test_file_hashes(files_hash, test_files_hash)
    assert(file_hashes_match, "The file hashes should match.")
  end
end

