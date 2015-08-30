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
    WebConsole::run_plugin(TEST_PLUGIN_NAME, TEST_PLUGIN_PATH)
   
    # Setup the window
    # TODO I shouldn't need this sleep when testing reading from standard input

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
    title = @view.do_javascript(TEST_TITLE_JAVASCRIPT)
    title.chomp!
    assert_equal(title, TEST_PLUGIN_NAME, "The title should equal the test html title.")
  end

end
