require 'Shellwords'

require File.join(File.expand_path(File.dirname(__FILE__)), "test_constants") 

module TestsHelper
  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end

  CONFIRMDIALOGAPPLESCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "confirm_dialog.applescript")
  def self.confirm_dialog
    `osascript #{Shellwords.escape(CONFIRMDIALOGAPPLESCRIPT_FILE)}`
  end
end
