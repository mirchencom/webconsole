#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/dependencies"
require_relative "../lib/input_controller"
require_relative "../lib/window_manager"
require_relative "../lib/output_controller"

class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    ENV[WebConsole::PLUGIN_NAME_KEY] = "Coffee"
    passed = WcCoffee.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end

class TestOutputController < Test::Unit::TestCase
  
  def setup
    @window_manager = WcCoffee::WindowManager.new
    WcCoffee::InputController.new(@window_manager) # Just to get the window_manager loaded with resources
    @output_controller = WcCoffee::OutputController.new(@window_manager)
  end
  
  def teardown
    @window_manager.close
  end

  def test_output_controller
    test_text = "Some test text"
    @output_controller.parse_output(test_text)
    @output_controller.parse_output("\x1b0000coffee>")
    
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end

end