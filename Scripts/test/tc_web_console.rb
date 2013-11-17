#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'
require 'webconsole'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
DATA_DIRECTORY = File.join(SCRIPT_DIRECTORY, "data")

module WebConsoleTestsHelper
  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end

  CONFIRMDIALOGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "confirm_dialog.scpt")
  def self.confirm_dialog
    self.run_applescript(CONFIRMDIALOGAPPLESCRIPT_FILE)
  end

  CANCELDIALOGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "cancel_dialog.scpt")
  def self.cancel_dialog
    self.run_applescript(CANCELDIALOGAPPLESCRIPT_FILE)
  end

  QUITAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "quit.scpt")
  def self.quit
    self.run_applescript(QUITAPPLESCRIPT_FILE)
    puts "ran quit"
  end

  ISRUNNINGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "is_running.scpt")
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
    sleep 0.5 # Give the plugin time to finish running
    WebConsoleTestsHelper::quit
    assert(!WebConsoleTestsHelper::is_running, "The application should not be running.")
  end

  PRINTPLUGIN_PATH = File.join(DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  def test_quit_with_running_task
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    WebConsoleTestsHelper::quit
    WebConsoleTestsHelper::confirm_dialog
    assert(!WebConsoleTestsHelper::is_running, "The application should not be running.")
  end

  def test_cancel_quit_with_running_task
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    WebConsoleTestsHelper::quit
    WebConsoleTestsHelper::cancel_dialog

    # sleep 2.0 # Give the cancel dialog time
    assert(WebConsoleTestsHelper::is_running, "The application should be running.")
    # TODO Assert that the process is still running here

    WebConsoleTestsHelper::quit
    WebConsoleTestsHelper::confirm_dialog
    assert(!WebConsoleTestsHelper::is_running, "The application should not be running.")
  end
end