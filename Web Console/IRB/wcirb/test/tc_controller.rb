#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE

require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

class TestController < Test::Unit::TestCase

  LASTCODEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "lastcode.js")
  def test_controller
    window_manager = WcIRB::WindowManager.new
    controller = WcIRB::Controller.new(window_manager)
    
    test_text = "Some test text"
    controller.parse_line(test_text)

    javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")

    window_manager.close
  end

end