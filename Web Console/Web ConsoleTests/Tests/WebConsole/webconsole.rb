require 'Shellwords'

class WebConsole
  SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
  APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "AppleScript")

  attr_writer :base_url
  def initialize
  end

  def base_url_path=(value)
    @base_url = "file://" + value
  end

  LOADHTML_FILENAME = "Load HTML.scpt"
  LOADHTML_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, LOADHTML_FILENAME)
  LOADHTMLWITHBASEURL_FILENAME = "Load HTML With Base URL.scpt"
  LOADHTMLWITHBASEURL_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, LOADHTMLWITHBASEURL_FILENAME)
  def load_html(html)
    if @base_url
      result = self.class.run_applescript(LOADHTMLWITHBASEURL_SCRIPT, [html, @base_url])
    else
      result = self.class.run_applescript(LOADHTML_SCRIPT, [html])
    end
    @window_id = self.class.window_id_from_result(result)
  end

  DOJAVASCRIPT_FILENAME = "Do JavaScript.scpt"
  DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, DOJAVASCRIPT_FILENAME)
  def do_javascript(javascript)
    self.class.run_applescript(DOJAVASCRIPT_SCRIPT, [javascript, @window_id])
  end

  CLOSEWINDOW_FILENAME = "Close Window.scpt"
  CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, CLOSEWINDOW_FILENAME)
  def close
    self.class.run_applescript(CLOSEWINDOW_SCRIPT, [@window_id])
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

  def self.window_id_from_result(result)
    return result.split.last.to_i
  end
end