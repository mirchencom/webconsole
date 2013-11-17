#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'
require 'webconsole'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
DATA_DIRECTORY = File.join(SCRIPT_DIRECTORY, "data")

PAUSE_TIME = 0.5

module WebConsoleTestsHelper

  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end

  CONFIRMDIALOGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "confirm_dialog.applescript")
  def self.confirm_dialog
    self.run_applescript(CONFIRMDIALOGAPPLESCRIPT_FILE)
  end

  CANCELDIALOGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "cancel_dialog.applescript")
  def self.cancel_dialog
    self.run_applescript(CANCELDIALOGAPPLESCRIPT_FILE)
  end

  QUITAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "quit.applescript")
  def self.quit
    self.run_applescript(QUITAPPLESCRIPT_FILE)
  end

  ISRUNNINGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "is_running.applescript")
  def self.is_running
    result = self.run_applescript(ISRUNNINGAPPLESCRIPT_FILE)
    result.chomp!
    if result == "true"
      return true
    else
      return false
    end
  end

  private
  
  def self.run_applescript(applescript)
    `osascript #{Shellwords.escape(applescript)}`
  end

end


class TestQuit < Test::Unit::TestCase

  HELLOWORLDPLUGIN_PATH = File.join(DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_quit_after_task_finishes
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    sleep PAUSE_TIME # Give the plugin time to finish running
    WebConsoleTestsHelper::quit
    assert(!WebConsoleTestsHelper::is_running, "The application should not be running.")
  end

  PRINTPLUGIN_PATH = File.join(DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  def test_quit_with_running_task
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running
    WebConsoleTestsHelper::quit
    WebConsoleTestsHelper::confirm_dialog
    sleep PAUSE_TIME # Give the application time to quit
    assert(!WebConsoleTestsHelper::is_running, "The application should not be running.")
    # TODO Assert that the process is not running
  end
  def test_cancel_quit_with_running_task
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    # TODO Assert that the process is running
    WebConsoleTestsHelper::quit
    WebConsoleTestsHelper::cancel_dialog
    assert(WebConsoleTestsHelper::is_running, "The application should be running.")
    # TODO Assert that the process is running
    WebConsoleTestsHelper::quit
    WebConsoleTestsHelper::confirm_dialog
    sleep PAUSE_TIME # Give the application time to quit
    assert(!WebConsoleTestsHelper::is_running, "The application should not be running.")
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

