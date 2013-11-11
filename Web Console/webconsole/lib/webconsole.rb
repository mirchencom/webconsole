require 'Shellwords'

module WebConsole
  SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
  APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "applescript")

  RUN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "run.scpt")
  def self.run_plugin(name, directory = nil, arguments = nil)
    parameters = [name]
    if directory
      parameters.push(directory)
    end
    if arguments
      parameters = parameters + arguments
    end
    self.run_applescript(RUN_SCRIPT, parameters)
  end

  PLUGIN_HAS_WINDOWS_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "plugin_has_windows.scpt")
  def self.plugin_has_windows(name)
    result = self.run_applescript(PLUGIN_HAS_WINDOWS_SCRIPT, [name])
    result.chomp!
    if result == "true"
      return true
    else
      return false
    end
  end

  WINDOW_ID_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "window_id_for_plugin.scpt")
  def self.window_id_for_plugin(name)
    result = self.run_applescript(WINDOW_ID_FOR_PLUGIN_SCRIPT, [name])
    result.chomp!
    return result
  end

  PLUGIN_READ_FROM_STANDARD_INPUT = File.join(APPLESCRIPT_DIRECTORY, "plugin_read_from_standard_input.scpt")
  def self.plugin_read_from_standard_input(name, text)
    self.run_applescript(PLUGIN_READ_FROM_STANDARD_INPUT, [name, text])
  end

  private

  def self.run_applescript(script, arguments)
    command = "osascript #{Shellwords.escape(script)}"
    arguments.each { |argument|
      argument = argument.to_s
      command = command + " " + Shellwords.escape(argument)
    }
    return `#{command}`
  end

  class WindowManager

    attr_writer :base_url
    def initialize(window_id = nil)
      @window_id = window_id
    end

    def base_url_path=(value)
      @base_url = "file://" + value
    end

    LOADHTML_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_html.scpt")
    def load_html(html)
      arguments = [html]

      if @base_url
        arguments.push(@base_url)
      end

      if @window_id
        arguments.push(@window_id)
      end

      result = WebConsole::run_applescript(LOADHTML_SCRIPT, arguments)
      @window_id = self.class.window_id_from_result(result)
    end

    DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "do_javascript_in.scpt")
    def do_javascript(javascript)
      WebConsole::run_applescript(DOJAVASCRIPT_SCRIPT, [javascript, @window_id])
    end

    CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "close_window.scpt")
    def close
      WebConsole::run_applescript(CLOSEWINDOW_SCRIPT, [@window_id])
    end

    private
    
    def self.window_id_from_result(result)
      return result.split.last.to_i
    end
  end
end