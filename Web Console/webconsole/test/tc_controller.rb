#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require CONSTANTS_FILE
require WebConsole::CONTROLLER_FILE
require WebConsole::WINDOW_MANAGER_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE


class TestWebConsoleController < Test::Unit::TestCase

  def test_controller
    window_manager = WebConsole::WindowManager.new
    controller = WebConsole::Controller.new(window_manager, TEST_TEMPLATE_FILE)

    # Testing jquery assures that `zepto.js` has been loaded correctly
    javascript = File.read(WebConsole::Tests::TEXTJQUERY_JAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)

    test_javascript = File.read(WebConsole::Tests::TEXT_JAVASCRIPT_FILE)
    expected = window_manager.do_javascript(test_javascript)

    assert_equal(expected, result, "The result should equal expected result.")
  end


  def test_controller_with_environment_variable  
    ENV[WebConsole::SHARED_RESOURCES_URL_KEY] = WebConsole::shared_resources_url.to_s
    WebConsole::Tests::Helper::quit
    controller = WebConsole::Controller.new(nil, TEST_TEMPLATE_FILE)
    assert(!WebConsole::Tests::Helper::is_running, "Web Console should not be running.")
  end

end
