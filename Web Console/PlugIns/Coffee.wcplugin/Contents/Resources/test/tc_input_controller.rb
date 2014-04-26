#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/dependencies"
require_relative "../lib/input_controller"
require_relative "../lib/window_manager"

class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    ENV[WebConsole::PLUGIN_NAME_KEY] = "Coffee"
    passed = WcCoffee.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end

class TestInputController < Test::Unit::TestCase

  def test_input_controller
    window_manager = WcCoffee::WindowManager.new
    input_controller = WcCoffee::InputController.new(window_manager)
    
    test_text = %Q[Some
test 
text]
    input_controller.parse_input(test_text.gsub("\n", "\uFF00"))
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!
    assert_equal(test_text, result, "The test text should equal the result.")

    window_manager.close
  end

end