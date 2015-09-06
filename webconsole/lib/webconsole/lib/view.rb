require_relative "window"
require_relative "view/javascript"
require_relative "view/erb"
require_relative "view/resources"

module WebConsole
  class View < Window

    # Properties

    def view_id
      if !@view_id
        if ENV.has_key?(VIEW_ID_KEY)
          @view_id = ENV[VIEW_ID_KEY]
        else
          @view_id = split_id
        end
      end
      return @view_id
    end

    # Web

    LOAD_HTML_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_html_in_split.scpt")
    LOAD_HTML_WITH_BASE_URL_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_html_with_base_url_in_split.scpt")
    def load_html(html)
      arguments = [html]

      script = LOAD_HTML_IN_SPLIT_SCRIPT

      if @base_url
        script = LOAD_HTML_WITH_BASE_URL_IN_SPLIT_SCRIPT
        arguments.push(@base_url)
      end

      arguments.push(view_id)

      WebConsole::run_applescript(script, arguments)
    end

    DO_JAVASCRIPT_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "do_javascript_in_split.scpt")
    def do_javascript(javascript)
      WebConsole::run_applescript(DO_JAVASCRIPT_IN_SPLIT_SCRIPT, [javascript, view_id])
    end

    READ_FROM_STANDARD_INPUT_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "read_from_standard_input_in_split.scpt")
    def read_from_standard_input(text)
      WebConsole::run_applescript(READ_FROM_STANDARD_INPUT_IN_SPLIT_SCRIPT, [text, view_id])
    end

  end
end