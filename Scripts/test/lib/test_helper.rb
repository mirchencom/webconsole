require 'Shellwords'

require File.join(File.expand_path(File.dirname(__FILE__)), "test_constants")

module TestsHelper

  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end

  CONFIRMDIALOGAPPLESCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "confirm_dialog.applescript")
  def self.confirm_dialog
    self.run_applescript(CONFIRMDIALOGAPPLESCRIPT_FILE)
    sleep PAUSE_TIME # Give dialog time
  end

  CANCELDIALOGAPPLESCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "cancel_dialog.applescript")
  def self.cancel_dialog
    self.run_applescript(CANCELDIALOGAPPLESCRIPT_FILE)
    sleep PAUSE_TIME # Give dialog time
  end

  QUITAPPLESCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "quit.applescript")
  def self.quit
    self.run_applescript(QUITAPPLESCRIPT_FILE)
  end

  ISRUNNINGAPPLESCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "is_running.applescript")
  def self.is_running
    result = self.run_applescript(ISRUNNINGAPPLESCRIPT_FILE)
    result.chomp!
    if result == "true"
      return true
    else
      return false
    end
  end

  SWITCHWINDOWSAPPLESCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "switch_windows.applescript")
  def self.switch_windows
    self.run_applescript(SWITCHWINDOWSAPPLESCRIPT_FILE)
  end

  private
  
  def self.run_applescript(script, arguments = nil)
    command = "osascript #{Shellwords.escape(script)}"
    if arguments
      arguments.each { |argument|
        argument = argument.to_s
        command = command + " " + Shellwords.escape(argument)
      }
    end
    return `#{command}`
  end

end