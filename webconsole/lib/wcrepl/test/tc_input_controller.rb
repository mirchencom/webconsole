#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require "webconsole"

require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/input_controller"
require_relative "../lib/window_manager"

class TestInputController < Test::Unit::TestCase

  def test_input_controller
    window_manager = WcREPL::WindowManager.new
    input_controller = WcREPL::InputController.new(window_manager)
    
    test_text = "Some test text"
    input_controller.parse_input(test_text)
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")

    window_manager.close
  end

end