#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require WEBCONSOLE_FILE
require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/output_controller"
require_relative "../lib/view"

class TestOutputController < Test::Unit::TestCase
  
  def setup
    @view = WebConsole::REPL::View.new
    @output_controller = WebConsole::REPL::OutputController.new
    @output_controller.view = @view
  end
  
  def teardown
    @view.close
  end

  def test_output_controller
    test_text = "Some test text"
    @output_controller.parse_output(test_text)
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @view.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end

  def test_remove_escape_sequence
    test_text = "Some test text"
    @output_controller.parse_output("\x1b0000m" + test_text)
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @view.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end
end