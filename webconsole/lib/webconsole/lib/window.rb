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

      return run_script(script, arguments)
    end

    DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "do_javascript.scpt")
    def do_javascript(javascript)
      return run_script(DOJAVASCRIPT_SCRIPT, [javascript])
    end

    READ_FROM_STANDARD_INPUT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "read_from_standard_input.scpt")
    def read_from_standard_input(text)
      run_script(READ_FROM_STANDARD_INPUT_SCRIPT, [text])
    end

    # Window

    CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "close_window.scpt")
    def close
      WebConsole::run_applescript(CLOSEWINDOW_SCRIPT, [window_id])
    end

    def split_id
      return WebConsole::split_id_in_window(window_id)
    end

    def split_id_last
      return WebConsole::split_id_in_window_last(window_id)
    end

    private

    def run_script(script, arguments = [])
      arguments = arguments_with_target(arguments)
      return WebConsole::run_applescript(script, arguments)
    end

    def arguments_with_target(arguments)
      arguments.push(window_id)
      return arguments
    end

  end
end
