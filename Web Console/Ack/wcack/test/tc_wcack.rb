#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

SCRIPT_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, 'lib', 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_DATA_PARSER_FILE
require TEST_APPLESCRIPT_HELPER_FILE
require TEST_JAVASCRIPT_HELPER_FILE
require TEST_DATA_TESTER_FILE

class TestWcAck < Test::Unit::TestCase

  WCACK_FILE = File.join(SCRIPT_DIRECTORY, "..", 'wcack.rb')
  WCACK_PLUGIN_NAME = 
  def test_controller
    # This test won't run from TextMate because the TextMate shell results window can't spawn a working `ack` process
    test_data_directory = TestHelper::TestData::test_data_directory
    test_search_term = TestHelper::TestData::test_search_term
    command = "#{Shellwords.escape(WCACK_FILE)} \"#{test_search_term}\" #{Shellwords.escape(test_data_directory)}"
    `#{command}`

    window_id = TestHelper::AppleScriptHelper::window_id
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