require_relative "view/javascript"
require_relative "view/erb"
require_relative "view/resources"

module WebConsole
  class View

    attr_reader :window_manager
    def initialize
      @window_manager = WebConsole::WindowManager.new
    end

    def base_url=(value)
      @window_manager.base_url = value
    end

    def base_url_path=(value)
      @window_manager.base_url_path = value
    end

    def load_html(html)
      @window_manager.load_html(html)
    end

    def do_javascript(javascript)
      return @window_manager.do_javascript(javascript)
    end

    def close
      @window_manager.close
    end

  end
end