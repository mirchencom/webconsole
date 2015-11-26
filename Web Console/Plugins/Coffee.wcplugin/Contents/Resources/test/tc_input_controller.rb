#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/dependencies"
require_relative "../lib/input_controller"
require_relative "../lib/view"

class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    passed = WebConsole::REPL::Coffee.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end

class TestInputController < Test::Unit::TestCase

  def setup
    view = WebConsole::REPL::Coffee::View.new
    @input_controller = WebConsole::REPL::Coffee::InputController.new(view)
  end
  
  def teardown
    @input_controller.view.close
  end

  def test_input_controller
    test_text = %Q[Some
test 
text]
    @input_controller.parse_input(test_text.gsub("\n", "\uFF00"))
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @input_controller.view.do_javascript(javascript)
    result.strip!
    assert_equal(test_text, result, "The test text should equal the result.")
  end

end