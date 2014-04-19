module WcDependencies
  class Checker
    def initialize(delegate = nil)
      @delegate = delegate
    end
    
    def check(name, type)
      case type
      when :shell_command
        check_shell_command(name)
      end
    end
    
    private
    
    require 'shellwords'
    def check_shell_command(name)
      command = "type -a #{Shellwords.escape(name)} > /dev/null 2>&1"
      result = system(command)
      puts result

      if @delegate
        # TODO Notify delegate of result
      end
    end

  end
end
