module WebConsole
  class WindowManager
    WEBCONSOLE_CONSTANTS = File.join(File.dirname(__FILE__), "constants")
    require WEBCONSOLE_CONSTANTS

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

      if window_id
        arguments.push(window_id)
      end

      result = WebConsole::run_applescript(LOADHTML_SCRIPT, arguments)
      if !window_id
        # This allows a window manager created without a window_id and then be assigned the window_id when load_html is called.
        @window_id = self.class.window_id_from_result(result)        
      end
    end

    DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "do_javascript.scpt")
    def do_javascript(javascript)
      WebConsole::run_applescript(DOJAVASCRIPT_SCRIPT, [javascript, window_id])
    end

    CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "close_window.scpt")
    def close
      WebConsole::run_applescript(CLOSEWINDOW_SCRIPT, [window_id])
    end
    
    def window_id
      if !@window_id && ENV.has_key?(WINDOW_ID_KEY)
        @window_id = ENV[WINDOW_ID_KEY]
      end
      return @window_id
    end

    private
    
    def self.window_id_from_result(result)
      return result.split.last.to_i
    end
  end
end