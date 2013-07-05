require 'Shellwords'

module WebConsole
  SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
  APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "applescript")

  RUN_PLUGIN_WITH_ARGUMENTS_IN_DIRECTORY_FILENAME = "run_plugin_with_arguments_in_directory.scpt"
  RUN_PLUGIN_WITH_ARGUMENTS_IN_DIRECTORY_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, RUN_PLUGIN_WITH_ARGUMENTS_IN_DIRECTORY_FILENAME)
  def self.run_plugin(name, arguments = nil, directory = nil)
    parameters = [name]
    if arguments
      parameters = parameters + arguments
    end
    if directory
      parameters.push(directory)
    end
    self.run_applescript(RUN_PLUGIN_WITH_ARGUMENTS_IN_DIRECTORY_SCRIPT, parameters)
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
    def initialize
    end

    def base_url_path=(value)
      @base_url = "file://" + value
    end

    LOADHTML_FILENAME = "load_html.scpt"
    LOADHTML_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, LOADHTML_FILENAME)
    LOADHTMLWITHBASEURL_FILENAME = "load_html_with_base_url.scpt"
    LOADHTMLWITHBASEURL_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, LOADHTMLWITHBASEURL_FILENAME)
    def load_html(html)
      if @base_url
        result = WebConsole::run_applescript(LOADHTMLWITHBASEURL_SCRIPT, [html, @base_url])
      else
        result = WebConsole::run_applescript(LOADHTML_SCRIPT, [html])
      end
      @window_id = self.class.window_id_from_result(result)
    end

    DOJAVASCRIPT_FILENAME = "do_javascript.scpt"
    DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, DOJAVASCRIPT_FILENAME)
    def do_javascript(javascript)
      WebConsole::run_applescript(DOJAVASCRIPT_SCRIPT, [javascript, @window_id])
    end

    CLOSEWINDOW_FILENAME = "close_window.scpt"
    CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, CLOSEWINDOW_FILENAME)
    def close
      WebConsole::run_applescript(CLOSEWINDOW_SCRIPT, [@window_id])
    end

    private
    
    def self.window_id_from_result(result)
      return result.split.last.to_i
    end
  end
end