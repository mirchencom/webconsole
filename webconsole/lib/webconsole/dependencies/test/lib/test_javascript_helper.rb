module WcDependencies
  module Tests
    module JavaScriptHelper
      def self.last_type(window_manager)
        result = window_manager.do_javascript('$(".type").last().text()')
        return result.chomp
      end

      def self.last_name(window_manager)
        result = window_manager.do_javascript('$(".name").last().text()')
        return result.chomp
      end

      def self.last_installation(window_manager)
        result = window_manager.do_javascript('$(".installation").last().html()')
        return result.chomp
      end

      def self.count_type(window_manager)
        result = window_manager.do_javascript('$(".type").length');
        return result.to_i
      end

      def self.count_name(window_manager)
        result = window_manager.do_javascript('$(".name").length');
        return result.to_i
      end

      def self.count_installation(window_manager)
        result = window_manager.do_javascript('$(".installation").length');
        return result.to_i
      end

    end
  end
end