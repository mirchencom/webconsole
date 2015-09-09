require_relative 'test_constants'

class TestViewHelper

    def initialize(window_id, view_id)
      @view = WebConsole::View.new(window_id, view_id)
    end

    def last_log_message
      return do_javascript(TEST_MESSAGE_JAVASCRIPT).chomp
    end
  
    def last_log_class
      return do_javascript(TEST_CLASS_JAVASCRIPT).chomp
    end
    

    private

    def do_javascript(javascript)
      return @view.do_javascript(javascript)
    end

end
