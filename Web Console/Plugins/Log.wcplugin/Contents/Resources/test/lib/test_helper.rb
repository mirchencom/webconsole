require_relative "test_constants"

module WebConsole::Log
  module Tests
    class TestHelper

      def initialize(view)
        @view = view
      end

      def last_log_class()
        @view.do_javascript(TEST_CLASS_JAVASCRIPT)
      end

      def last_log_message()
        @view.do_javascript(TEST_MESSAGE_JAVASCRIPT)
      end

    end
  end
end