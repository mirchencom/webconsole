require_relative "test_constants"

module WebConsole::Log
  module Tests
    class TestHelper

      def initialize(view)
        @view = view
      end

      def last_log_class()
        result = @view.do_javascript(TEST_CLASS_JAVASCRIPT)
        return result.chomp
      end

      def last_log_message()
        result = @view.do_javascript(TEST_MESSAGE_JAVASCRIPT)
        return result.chomp
      end

    end
  end
end