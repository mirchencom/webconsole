require_relative 'constants'
require 'Shellwords'

module Runner
  CREATE_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "create_window.scpt")
  def self.create_window
    self.run_applescript(CREATE_WINDOW_SCRIPT)
  end

  # Private

  def self.run_applescript(script, arguments = nil)
    command = "osascript #{script.shell_escape}"

    if arguments
      command += " " + arguments.compact.map(&:to_s).map(&:shell_escape).join(' ')
    end

    result = `#{command}`

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

