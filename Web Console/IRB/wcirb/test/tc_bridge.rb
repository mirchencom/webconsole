#!/usr/bin/env ruby

require "test/unit"
require "webconsole"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WC_TEST_HELPER_FILE

require TEST_PIPE_HELPER_FILE

class TestBridge < Test::Unit::TestCase


  LASTCODEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "lastcode.js")
  def test_controller
    test_text = "Some test text"
    
    bridge = TestHelper::PipeHelper.new(BRIDGE_FILE)
    bridge.write(test_text)
    bridge.close

    window_id = WebConsole::TestHelper::window_id
    window_manager = WebConsole::WindowManager.new(window_id)
    javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!
    
    assert_equal(test_text, result, "The test text should equal the result.")

    window_manager.close
  end

end