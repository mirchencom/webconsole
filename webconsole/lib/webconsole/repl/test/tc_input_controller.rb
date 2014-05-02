#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require WEBCONSOLE_FILE
require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/input_controller"
require_relative "../lib/view"

class TestInputController < Test::Unit::TestCase

  def test_input_controller
    view = WebConsole::REPL::View.new
    input_controller = WebConsole::REPL::InputController.new
    input_controller.view = view
    
    test_text = "Some test text"
    input_controller.parse_input(test_text)
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = view.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")

    view.close
  end

end