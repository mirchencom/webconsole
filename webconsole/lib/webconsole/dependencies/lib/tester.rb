module WebConsole::Dependencies
  module Tester
    def self.check(name, type)
      case type
      when :shell_command
        return check_shell_command(name)
      end
    end
    
    private
    
    require 'shellwords'
    def self.check_shell_command(name)
      command = "type -a #{Shellwords.escape(name)} > /dev/null 2>&1"
      return system(command)
    end

  end
end