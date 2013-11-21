#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'
TEST_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_HELPER_FILE = File.join(TEST_DIRECTORY, "test_helper")
require TEST_HELPER_FILE

QUIT_TIMEOUT = 60.0

class TestQuitTimeout < Test::Unit::TestCase

  PRINTPLUGIN_PATH = File.join(DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  def setup
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
  end

  def test_quit_timeout
    # Start a task with a long running process
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and wait for the quit timout before confirming the dialog
    TestsHelper::quit
    sleep QUIT_TIMEOUT
    TestsHelper::confirm_dialog
    assert(TestsHelper::is_running, "The application should be running.")
    # TODO Assert that the process is running

    # Quit and confirm the dialog
    TestsHelper::quit
    # Don't need to confirm the dialog because the window is closed
    assert(!TestsHelper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

end