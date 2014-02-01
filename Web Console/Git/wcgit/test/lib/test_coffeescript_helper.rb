require 'webconsole'

module WcGit
  module Tests
    module JavaScriptHelper
      COFFEESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "..", "coffee")
      COUNTELEMENT_COFFEESCRIPT_FILE = File.join(COFFEESCRIPT_DIRECTORY, "count_element.coffee")
      def self.files_hash_for_window_manager(window_manager)
        javascript = File.read(COUNTELEMENT_COFFEESCRIPT_FILE)
        return window_manager.do_javascript(javascript)
      end
    end
  end
end