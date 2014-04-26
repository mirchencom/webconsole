#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), 'lib', 'test_constants')
require TEST_CONSTANTS_FILE
require_relative "../lib/dependencies"

require INPUT_CONTROLLER_FILE
require WINDOW_MANAGER_FILE
require OUTPUT_CONTROLLER_FILE


class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    ENV[WebConsole::PLUGIN_NAME_KEY] = "Node"
    passed = WcNode.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end

class TestOutputController < Test::Unit::TestCase
  
  def setup
    @window_manager = WcNode::WindowManager.new
    WcNode::InputController.new(@window_manager) # Just to get the window_manager loaded with resources
    @output_controller = WcNode::OutputController.new(@window_manager)
  end
  
  def teardown
    @window_manager.close
  end

  def test_output_controller
    test_text = "Some test text"
    @output_controller.parse_output(test_text)
    @output_controller.parse_output("\e[1G\e[0J> \e[3Gconsole.log(\"test\");\r\r\n")

    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end

end