#!/usr/bin/env ruby

require "test/unit"

SCRIPT_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, 'lib', 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_DATA_PARSER_FILE
require TEST_JAVASCRIPT_HELPER_FILE
require TEST_PARSER_ADDITIONS_FILE
require PARSER_FILE
require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

class TestController < Test::Unit::TestCase

  def test_controller
    test_ack_output = TestHelper::TestData::test_ack_output
    test_data_directory = TestHelper::TestData::test_data_directory

    window_manager = WcAck::WindowManager.new
    controller = WcAck::Controller.new(window_manager)
    parser = WcAck::Parser.new(controller, test_data_directory)
    parser.parse(test_ack_output)

    files_hash = TestHelper::JavaScriptHelper::files_hash_for_window_manager(window_manager)
puts "files_hash = " + files_hash.to_s

  end
end