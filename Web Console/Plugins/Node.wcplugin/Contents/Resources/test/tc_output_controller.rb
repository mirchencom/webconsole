#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")

require_relative "../lib/dependencies"
require_relative "../lib/output_controller"
require_relative "../lib/view"

class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    passed = WebConsole::REPL::Node.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end

class TestOutputController < Test::Unit::TestCase
  
  def setup
    view = WebConsole::REPL::Node::View.new
    @output_controller = WebConsole::REPL::Node::OutputController.new(view)
  end
  
  def teardown
    @output_controller.view.close
  end

  def test_output_controller
    test_text = "Some test text"
    @output_controller.parse_output(test_text)
    @output_controller.parse_output("\e[1G\e[0J> \e[3Gconsole.log(\"test\");\r\r\n")

    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @output_controller.view.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end

end
