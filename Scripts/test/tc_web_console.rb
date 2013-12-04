#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

SCRIPT_DIRECTORY = File.dirname(__FILE__)
TEST_CONSTANTS_FILE = File.join(SCRIPT_DIRECTORY, "lib", "test_constants")
require TEST_CONSTANTS_FILE
require TEST_HELPER_FILE

class TestQuit < Test::Unit::TestCase

  HELLOWORLDPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_quit_after_task_finishes
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    sleep PAUSE_TIME # Give the plugin time to finish running
    TestsHelper::quit
    assert(!TestsHelper::is_running, "The application should not be running.")
  end

end

class TestQuitWithRunningTask < Test::Unit::TestCase

  PRINTPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  def setup
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
  end

  def test_quit_with_running_task
    # Start a task with a long running process
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and confirm the dialog
    TestsHelper::quit
    TestsHelper::confirm_dialog
    assert(!TestsHelper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

  def test_cancel_quit_with_running_task
    # Start a task with a long running process
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and cancel the dialog
    TestsHelper::quit
    TestsHelper::cancel_dialog
    assert(TestsHelper::is_running, "The application should be running.")
    # TODO Assert that the process is running

    # Quit and confirm the dialog
    TestsHelper::quit
    TestsHelper::confirm_dialog
    assert(!TestsHelper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

  def test_quit_confirming_after_starting_second_task
    # Start a task with a long running process
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and start another process
    TestsHelper::quit
    WebConsole::run_plugin(PRINTPLUGIN_NAME)

    # Switch windows and confirm close
    TestsHelper::switch_windows
    TestsHelper::confirm_dialog
    assert(TestsHelper::is_running, "The application should be running.")
    # TODO Assert that the process is running
  
    # Quit and confirm the dialog
    TestsHelper::quit
    TestsHelper::confirm_dialog
    assert(!TestsHelper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

  HELLOWORLDPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_quit_confirming_after_starting_short_second_task
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)

    # Start a task with a long running process
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and start another process
    TestsHelper::quit
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    sleep PAUSE_TIME # Give the plugin time to finish running    

    # Switch windows and confirm close
    TestsHelper::switch_windows
    TestsHelper::confirm_dialog
    assert(!TestsHelper::is_running, "The application should be running.")
    # TODO Assert that the process is not running  
  end

end

# TODO Test closing a window with a running task terminates the task
# 1. Run a plugin that runs a task that needs to be interrupted
# 2. Assert that the task is running
# 3. Tell the window to close
# 4. Confirm the close window dialog
# 5. Assert that the task is terminated
# 6. Assert that the plugin does not have windows

# TODO Test closing a window with a running task and canceling the close does not terminate the task
# 1. Run a plugin that runs a task that needs to be interrupted
# 2. Assert that the task is running
# 3. Tell the window to close
# 4. Cancel the close window dialog
# 5. Assert that the task is running
# 6. Assert that the plugin still has windows