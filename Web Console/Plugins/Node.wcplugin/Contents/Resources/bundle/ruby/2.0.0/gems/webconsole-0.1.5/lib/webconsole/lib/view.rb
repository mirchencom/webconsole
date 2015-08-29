require_relative "view/javascript"
require_relative "view/erb"
require_relative "view/resources"

module WebConsole
  class View

    attr_reader :window
    def initialize
      @window = WebConsole::Window.new
    end

    def base_url=(value)
      @window.base_url = value
    end

    def base_url_path=(value)
      @window.base_url_path = value
    end

    def load_html(html)
      @window.load_html(html)
    end

    def do_javascript(javascript)
      return @window.do_javascript(javascript)
    end

    def close
      @window.close
    end

  end
end