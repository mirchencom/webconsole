#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require WEBCONSOLE_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "../../repl"

class TestREPL < Test::Unit::TestCase
  def test_repl
    wrapper = WebConsole::REPL::Wrapper.new("irb")

    test_text = "1 + 1"
    test_result = "2"

    wrapper.parse_input(test_text + "\n")

    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed

    window_id = WebConsole::Tests::Helper::window_id
    window = WebConsole::Window.new(window_id)

    # Test Wrapper Input
    javascript = File.read(WebConsole::Tests::FIRSTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    result.strip!
    assert_equal(test_text, result, "The test text should equal the result.")

    # Test Wrapper Output
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    result.strip!
    result.sub!("=&gt; ", "") # Remove the prompt that irb adds    
    assert_equal(result, test_result, "The test result should equal the result.")

    window.close
  end

end
