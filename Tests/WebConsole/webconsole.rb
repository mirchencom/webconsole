require 'Shellwords'

class WebConsole
  SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
  APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "AppleScript")


  def initialize
    @window_id
  end

  LOADHTML_FILENAME = "Load HTML.scpt"
  LOADHTML_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, LOADHTML_FILENAME)
  def load_html(html)

    # load_html should use the current window if it has one and new one if not
    result = self.class.run_applescript(LOADHTML_SCRIPT, [html])

    @window_id = self.class.window_id_from_result(result)
puts "@window_id = " + @window_id.to_s

  end

  DOJAVASCRIPT_FILENAME = "Do JavaScript.scpt"
  DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, DOJAVASCRIPT_FILENAME)
  def do_javascript(javascript)
    
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