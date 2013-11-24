#!/usr/bin/env ruby

require "test/unit"

TEST_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_HELPER_FILE = File.join(TEST_DIRECTORY, "test_helper")
require TEST_HELPER_FILE

LIB_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'lib')

PARSER_FILE = File.join(LIB_DIRECTORY, 'parser')
require PARSER_FILE

CONTROLLER_FILE = File.join(LIB_DIRECTORY, 'controller')
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(LIB_DIRECTORY, 'window_manager')
require WINDOW_MANAGER_FILE


class TestController < Test::Unit::TestCase

  def test_controller
      window_manager = WcAck::WindowManager.new
      parser = WcAck::Parser.new
      parser.delegate = WcAck::Controller.new(window_manager)

      test_helper = TestHelper.new
      test_data = test_helper.test_data

      test_files_hash = test_helper.test_files_hash

      files_hash = WcAck.load(test_data)    
  end
end