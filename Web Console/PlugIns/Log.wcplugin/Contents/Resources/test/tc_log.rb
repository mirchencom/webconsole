#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestPlugin < Test::Unit::TestCase

  # Life Cycle
  
  def setup
    WebConsole::load_plugin(TEST_PLUGIN_PATH)
    # Run the plugin
    WebConsole::run_plugin(TEST_PLUGIN_NAME)
    
    # Setup the window
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give the plugin time to finish running
    window_id = WebConsole::window_id_for_plugin(TEST_PLUGIN_NAME)
    @window = WebConsole::Window.new(window_id)
  end

  def teardown
    WebConsole::Tests::Helper::quit
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

  # Tests

  def test_log
    # Confirm the title
    title = @window.do_javascript(TEST_TITLE_JAVASCRIPT)
    title.chomp!
    assert_equal(title, TEST_PLUGIN_NAME, "The title should equal the test html title.")

    # Test Info
    message = "Testing log info"
    log_info(message)
    test_message = last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = last_log_class()
    assert_equal("info", test_class, "The classes should match")

    # Test Error
    message = "Testing log error"
    log_error(message)
    test_message = last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = last_log_class()
    assert_equal("error", test_class, "The classes should match")

    # Test Warning
    message = "Testing log warning"
    log_warning(message)
    test_message = last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = last_log_class()
    assert_equal("warning", test_class, "The classes should match")

  end

  # Helper
  def last_log_class()
    result = @window.do_javascript(TEST_CLASS_JAVASCRIPT)
    return result.chomp
  end

  def last_log_message()
    result = @window.do_javascript(TEST_MESSAGE_JAVASCRIPT)
    return result.chomp
  end

  def log_info(message)
    javascript = WebConsole::View::javascript_function("info", [message])
    @window.do_javascript(javascript)
  end

  def log_error(message)
    javascript = WebConsole::View::javascript_function("error", [message])
    @window.do_javascript(javascript)
  end

  def log_warning(message)
    javascript = WebConsole::View::javascript_function("warning", [message])
    @window.do_javascript(javascript)
  end

end
