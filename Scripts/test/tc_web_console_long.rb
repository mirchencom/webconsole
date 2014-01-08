#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestQuitTimeout < Test::Unit::TestCase

  QUIT_TIMEOUT = 60.0

  def setup
    WebConsole::load_plugin(WebConsole::Tests::PRINT_PLUGIN_FILE)
  end

  def test_quit_timeout
    # Start a task with a long running process
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and wait for the quit timout before confirming the dialog
    WebConsole::Tests::Helper::quit
    sleep QUIT_TIMEOUT
    WebConsole::Tests::Helper::confirm_dialog
    assert(WebConsole::Tests::Helper::is_running, "The application should be running.")
    # TODO Assert that the process is running

    # Quit and confirm the dialog
    WebConsole::Tests::Helper::quit
    # Don't need to confirm the dialog because the window is closed
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

end
