#!/usr/bin/env ruby

require "test/unit"

SCRIPT_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, 'test_constants')
require TEST_CONSTANTS_FILE

require TEST_DATA_HELPER_FILE
require TEST_PARSER_ADDITIONS_FILE
require PARSER_FILE
require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

class TestController < Test::Unit::TestCase

  def test_controller
    test_data_helper = TestDataHelper.new
    test_data = test_data_helper.test_data

    parser = WcAck::Parser.new(WcAck::Controller.new(WcAck::WindowManager.new))
    parser.parse(test_data)

    # test_files_hash = test_data_helper.test_files_hash
  end
end