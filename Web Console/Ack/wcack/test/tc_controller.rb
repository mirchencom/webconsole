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

    window_manager = WcAck::WindowManager.new
    parser = WcAck::Parser.new(WcAck::Controller.new(window_manager))
    parser.parse(test_ack_output)



    # TestHelper::JavaScriptHelper::files_hash_for_window_manager(window_manager)
  end
end