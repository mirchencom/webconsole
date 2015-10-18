module WebConsole::Dependencies
  module Tests
    module JavaScriptHelper
      def self.last_type(window_manager)
        return window_manager.do_javascript('$(".type").last().text()')
      end

      def self.last_name(window_manager)
        return window_manager.do_javascript('$(".name").last().text()')
      end

      def self.last_installation(window_manager)
        return window_manager.do_javascript('$(".installation").last().html()')
      end

      def self.count_type(window_manager)
        return window_manager.do_javascript('$(".type").length')
      end

      def self.count_name(window_manager)
        return window_manager.do_javascript('$(".name").length')
      end

      def self.count_installation(window_manager)
        return window_manager.do_javascript('$(".installation").length')
      end

    end
  end
end