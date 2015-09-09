class TestViewHelper

    def initialize(window_id, view_id)
      @view = WebConsole::View.new(window_id, view_id)
    end

    def do_javascript(javascript)
      return @view.do_javascript(javascript)
    end

end
