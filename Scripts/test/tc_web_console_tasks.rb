#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestQuit < Test::Unit::TestCase

  def test_quit_after_task_finishes
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give the plugin time to finish running
    WebConsole::Tests::Helper::quit
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

end

class TestQuitWithRunningTask < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(WebConsole::Tests::PRINT_PLUGIN_FILE)
  end

  def test_quit_with_running_task
    # Start a task with a long running process
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and confirm the dialog
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

  def test_cancel_quit_with_running_task
    # Start a task with a long running process
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and cancel the dialog
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::cancel_dialog
    assert(WebConsole::Tests::Helper::is_running, "The application should be running.")
    # TODO Assert that the process is running

    # Quit and confirm the dialog
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

  def test_quit_confirming_after_starting_second_task
    # Start a task with a long running process
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and start another process
    WebConsole::Tests::Helper::quit
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)

    # Switch windows and confirm close
    WebConsole::Tests::Helper::switch_windows
    WebConsole::Tests::Helper::confirm_dialog
    assert(WebConsole::Tests::Helper::is_running, "The application should be running.")
    # TODO Assert that the process is running
  
    # Quit and confirm the dialog
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end

  def test_quit_confirming_after_starting_short_second_task
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)

    # Start a task with a long running process
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    # TODO Assert that the process is running

    # Quit and start another process
    WebConsole::Tests::Helper::quit
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give the plugin time to finish running    

    # Switch windows and confirm close
    WebConsole::Tests::Helper::switch_windows
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should be running.")
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
