#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), 'lib', 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_DATA_PARSER_FILE
require TEST_JAVASCRIPT_HELPER_FILE
require TEST_PARSER_ADDITIONS_FILE
require TEST_DATA_TESTER_FILE
require PARSER_FILE
require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

class TestController < Test::Unit::TestCase

  def test_controller
    test_search_output = TestHelper::TestData::test_search_output
    test_data_directory = TestHelper::TestData::test_data_directory

    window_manager = WcSearch::WindowManager.new
    controller = WcSearch::Controller.new(window_manager)
    parser = WcSearch::Parser.new(controller, test_data_directory)
    parser.parse(test_search_output)

    files_json = TestHelper::JavaScriptHelper::files_hash_for_window_manager(window_manager)
    files_hash = TestHelper::Parser::parse(files_json)

    test_data_json = TestHelper::TestData::test_data_json
    test_files_hash = TestHelper::Parser::parse(test_data_json)

    file_hashes_match = TestHelper::TestDataTester::test_file_hashes(files_hash, test_files_hash)
    assert(file_hashes_match, "The file hashes should match.")

    window_manager.close
  end

end