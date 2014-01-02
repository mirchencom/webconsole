require 'Shellwords'

module TestHelper
  module AppleScriptHelper
    APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "..", "applescript")

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
          if argument
            argument = argument.to_s
            command = command + " " + Shellwords.escape(argument)
          end
        }
      end
      return `#{command}`
    end

  end
end

