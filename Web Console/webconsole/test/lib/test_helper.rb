require 'Shellwords'

TEST_HELPER_DIRECTORY = File.expand_path(File.dirname(__FILE__))
WEBCONSOLE_FILE = File.join(TEST_HELPER_DIRECTORY, "..", "..", "lib", "webconsole")
require WEBCONSOLE_FILE
DATA_DIRECTORY = File.expand_path(File.join(TEST_HELPER_DIRECTORY, "..", "data"))

PAUSE_TIME = 0.5

module TestsHelper
  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end

  CONFIRMDIALOGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "confirm_dialog.applescript")
  def self.confirm_dialog
    `osascript #{Shellwords.escape(CONFIRMDIALOGAPPLESCRIPT_FILE)}`
  end
end
