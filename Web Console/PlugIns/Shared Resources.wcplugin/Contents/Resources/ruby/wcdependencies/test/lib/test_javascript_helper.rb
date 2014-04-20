require 'webconsole'

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

    end
  end
end