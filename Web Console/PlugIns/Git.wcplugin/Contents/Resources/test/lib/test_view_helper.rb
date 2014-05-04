require_relative '../../bundle/bundler/setup'
require 'webconsole'

module WebConsole::Git
  module Tests
    class ViewHelper

      COFFEESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "..", "coffee")
      TESTHELPER_COFFEESCRIPT_FILE = File.join(COFFEESCRIPT_DIRECTORY, "test_helper.coffee")
      def initialize(view)
        @view = view

        coffeescript = File.read(TESTHELPER_COFFEESCRIPT_FILE)
        @view.do_coffeescript(coffeescript)
      end

      def element_count_for_selector(selector)
        coffeescript = "return wcTestHelper.elementCount('#{selector}')"
        return @view.do_coffeescript(coffeescript)
      end
    end
  end
end