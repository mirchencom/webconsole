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

  # def teardown
  #   WebConsole::Tests::Helper::quit
  #   assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  # end

  # Tests

  def test_log
    # Confirm the title
    title = @window.do_javascript(TEST_TITLE_JAVASCRIPT)
    title.chomp!
    assert_equal(title, TEST_PLUGIN_NAME, "The title should equal the test html title.")

    log_info("Testing log info")

  end

  # Helper

  def log_info(message)
    a_function = WebConsole::View::javascript_function("info", [message])
    @window.do_javascript(a_function)
  end

  def logError(message)
  end

  def logWarning(message)
  end

end
