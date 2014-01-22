#!/usr/bin/env ruby

require "test/unit"
require "webconsole"

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE
TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE

require TEST_PIPE_HELPER_FILE

class TestWcCoffee < Test::Unit::TestCase

  WCCOFFEE_FILE = File.join(File.dirname(__FILE__), "..", 'wccoffee.rb')
  def test_wccoffee
    test_text = "1 + 1\n"
    test_result = "2"
    
    bridge = WcCoffee::Tests::PipeHelper.new(WCCOFFEE_FILE)
    bridge.write(test_text)
    bridge.close

    window_id = WebConsole::Tests::Helper::window_id
    window_manager = WebConsole::WindowManager.new(window_id)
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!
    
    assert_equal(result, test_result, "The test result should equal the result.")

    window_manager.close
  end

end
