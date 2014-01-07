#!/usr/bin/env ruby

require "test/unit"
require "webconsole"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WC_TEST_HELPER_FILE

require TEST_PIPE_HELPER_FILE

class TestWcIRB < Test::Unit::TestCase

  WCIRB_FILE = File.join(File.dirname(__FILE__), "..", 'wcirb.rb')
  LASTCODEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "lastcode.js")
  def test_wcirb
    test_text = "1 + 1\n"
    test_result = "2"
    
    bridge = TestHelper::PipeHelper.new(WCIRB_FILE)
    bridge.write(test_text)
    bridge.close

    window_id = WebConsole::Tests::Helper::window_id
    window_manager = WebConsole::WindowManager.new(window_id)
    javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!
    
    assert_equal(result, test_result, "The test result should equal the result.")

    window_manager.close
  end

end
