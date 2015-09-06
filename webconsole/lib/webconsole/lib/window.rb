module WebConsole
  class Window
    require_relative "constants"

    attr_writer :base_url

    def initialize(window_id = nil)
      @window_id = window_id
    end

    # Properties

    def base_url_path=(value)
      @base_url = "file://" + value
    end
    
    def window_id
      if !@window_id
        if ENV.has_key?(WINDOW_ID_KEY)
          @window_id = ENV[WINDOW_ID_KEY]
        else
          @window_id = WebConsole::create_window
        end
      end
      return @window_id
    end
    
    # Web

    LOADHTML_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_html.scpt")
    LOADHTMLWITHBASEURL_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_html_with_base_url.scpt")
    def load_html(html)
      arguments = [html]

      script = LOADHTML_SCRIPT

      if @base_url
        script = LOADHTMLWITHBASEURL_SCRIPT
        arguments.push(@base_url)
      end

      arguments.push(window_id)

      WebConsole::run_applescript(script, arguments)
    end

    DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "do_javascript.scpt")
    def do_javascript(javascript)
      WebConsole::run_applescript(DOJAVASCRIPT_SCRIPT, [javascript, window_id])
    end

    READ_FROM_STANDARD_INPUT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "read_from_standard_input.scpt")
    def read_from_standard_input(text)
      WebConsole::run_applescript(READ_FROM_STANDARD_INPUT_SCRIPT, [text, window_id])
    end

    # Window

    CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "close_window.scpt")
    def close
      WebConsole::run_applescript(CLOSEWINDOW_SCRIPT, [window_id])
    end

    # Splits

    SPLIT_ID_IN_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "split_id_in_window.scpt")
    def split_id(pluginName = nil)
      arguments = [window_id]

      if pluginName
        arguments.push(pluginName)
      end

      result = self.run_applescript(SPLIT_ID_IN_WINDOW_SCRIPT, [arguments])
      result.chomp!
      return result
    end

  end
end
