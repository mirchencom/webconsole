require 'Shellwords'

module TestHelper
  module AppleScriptHelper
    TEST_APPLESCRIPT_HELPER_DIRECTORY = File.expand_path(File.dirname(__FILE__))
    APPLESCRIPT_DIRECTORY = File.join(TEST_APPLESCRIPT_HELPER_DIRECTORY, "..", "applescript")

    WINDOW_ID_APPLESCRIPT_FILE = File.join(APPLESCRIPT_DIRECTORY, "window_id.applescript")
    def self.window_id
      result = self.run_applescript(WINDOW_ID_APPLESCRIPT_FILE)
      result.chomp!
      return result      
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
end

