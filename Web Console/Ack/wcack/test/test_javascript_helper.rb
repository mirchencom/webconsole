require 'webconsole'

TEST_JAVASCRIPT_HELPER_DIRECTORY = File.expand_path(File.dirname(__FILE__))
JAVASCRIPT_DIRECTORY = File.join(TEST_JAVASCRIPT_HELPER_DIRECTORY, "js")

module TestJavaScriptHelper
  DOMTOJSON_JAVASCRIPT_FILE = File.join(JAVASCRIPT_DIRECTORY, "dom_to_json.js")
  def self.files_hash_for_window_manager(window_manager)
    javascript = File.read(DOMTOJSON_JAVASCRIPT_FILE)
    json = window_manager.do_javascript(javascript)
puts "json = " + json.to_s

  end
end