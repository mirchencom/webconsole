#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative 'bundle/bundler/setup'
require 'webconsole'

require_relative "constants"

class ::String
  def is_integer?
    self.to_i.to_s == self
  end
end

class TestEnviroment < Test::Unit::TestCase

  def test_plugin_name_key
    assert(ENV.has_key?(PLUGIN_NAME_KEY), "The plugin name key should exist.")
    plugin_name = ENV[PLUGIN_NAME_KEY]
    assert_equal(plugin_name, TEST_PLUGIN_NAME, "The plugin name should equal the test plugin name.")
  end

  def test_window_id_key
    assert(ENV.has_key?(WINDOW_ID_KEY), "The window id key should exist.")
    window_id = ENV[WINDOW_ID_KEY]
    assert(window_id.is_integer?, "The window id should be an integer.")
    assert(window_id.to_i > 0, "The window id should be greater than zero.")
  end

  def test_shared_resources_path_key
    assert(ENV.has_key?(SHARED_RESOURCES_PATH_KEY), "The shared resources path key should exist.")
    shared_resources_path = ENV[SHARED_RESOURCES_PATH_KEY]

puts "shared_resources_path = " + shared_resources_path.to_s

  end

end


# I should be able to access a resource at the SHARED_RESOURCES_PATH_KEY
# I should be able to access a resource at the SHARED_RESOURCES_URL_KEY
# I should test the PLUGIN_NAME_KEY
# The WINDOW_ID_KEY should non-negative




# ENV[PLUGIN_NAME_KEY]
# 
# puts PLUGIN_NAME_KEY
# puts WINDOW_ID_KEY
# puts SHARED_RESOURCES_PATH_KEY
# puts SHARED_RESOURCES_URL_KEY
# 
# puts "about to exit"
# exit 1