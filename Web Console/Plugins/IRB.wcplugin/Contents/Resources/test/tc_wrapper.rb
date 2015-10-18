#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "lib/test_constants"
require_relative "../lib/wrapper"

class TestWrapper < Test::Unit::TestCase
  def test_wrapper
    wrapper = WebConsole::REPL::IRB::Wrapper.new

    test_code = TEST_CODE.gsub("\n", "\uFF00") + "\n"
    wrapper.parse_input(test_code)

    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed

    window_id = WebConsole::Tests::Helper::window_id
    window = WebConsole::Window.new(window_id)
    
    # Test Wrapper Input
    javascript = File.read(WebConsole::Tests::FIRSTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    result.strip!
    result.gsub!(/<\/?span.*?>/, "") # Remove spans adding by highlight.js
    assert_equal(TEST_CODE, result, "The test text should equal the result.")

    # Test Wrapper Output
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    assert_equal(result, TEST_CODE_RESULT, "The test result should equal the result.")
    
    window.close
  end

end
