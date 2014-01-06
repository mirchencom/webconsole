#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'
require 'webconsole'

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), 'lib', 'test_constants')
require TEST_CONSTANTS_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WC_TEST_HELPER_FILE

require TEST_DATA_HELPER_FILE
require TEST_DATA_PARSER_FILE
require TEST_JAVASCRIPT_HELPER_FILE
require TEST_DATA_TESTER_FILE

class TestWcSearch < Test::Unit::TestCase

  WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", 'wcsearch.rb')
  def test_controller
    test_data_directory = TestHelper::TestData::test_data_directory
    test_search_term = TestHelper::TestData::test_search_term
    command = "#{Shellwords.escape(WCSEARCH_FILE)} \"#{test_search_term}\" #{Shellwords.escape(test_data_directory)}"
    `#{command}`

    window_id = WebConsole::TestHelper::window_id
    window_manager = WebConsole::WindowManager.new(window_id)

    files_json = TestHelper::JavaScriptHelper::files_hash_for_window_manager(window_manager)
    files_hash = TestHelper::Parser::parse(files_json)

    test_data_json = TestHelper::TestData::test_data_json
    test_files_hash = TestHelper::Parser::parse(test_data_json)

    file_hashes_match = TestHelper::TestDataTester::test_file_hashes(files_hash, test_files_hash)
    assert(file_hashes_match, "The file hashes should match.")

    window_manager.close
  end

end
