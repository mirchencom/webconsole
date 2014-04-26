#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "../lib/webconsole"
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
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give time for application to quit
    assert(!WebConsole::Tests::Helper::is_running, "Web Console should not be running.")
  end

end
