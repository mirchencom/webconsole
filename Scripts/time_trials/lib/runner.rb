require_relative 'constants'
require 'Shellwords'

module Runner
  CREATE_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "create_window.scpt")
  def self.create_window
    self.run_applescript(CREATE_WINDOW_SCRIPT)
  end

  # Private

  def self.run_applescript(script, arguments = nil, input = nil)
    shell_arguments = ""
    if arguments
      shell_arguments = arguments.compact.map(&:to_s).map(&:shell_escape).join(' ')
    end

    if input
      ENV["WCINPUT"] = input
      result = `echo $WCINPUT | osascript 3<&0 #{script.shell_escape} #{shell_arguments}`
    else
      result = `osascript #{script.shell_escape} #{shell_arguments}`
    end

    result.chomp!

    return nil if result.empty?
    return result.to_i if result.is_integer?
    return result.to_f if result.is_float?
  
    result
  end

  class ::String
    def is_float?
      true if Float(self) rescue false
    end

    def is_integer?
      self.to_i.to_s == self
    end

    def shell_escape
      Shellwords.escape(self)
    end

    def shell_escape!
      replace(shell_escape)
    end

  end

  class ::Float
    alias_method :javascript_argument, :to_s
  end

  class ::Integer
    alias_method :javascript_argument, :to_s
  end

end

