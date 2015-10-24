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
    assert(ENV.has_key?(WebConsole::PLUGIN_NAME_KEY), "The plugin name key should exist.")
    plugin_name = ENV[WebConsole::PLUGIN_NAME_KEY]
    assert_equal(plugin_name, TEST_PLUGIN_NAME, "The plugin name should equal the test plugin name.")
  end

  def test_split_id_key
    assert(ENV.has_key?(WebConsole::SPLIT_ID_KEY), "The split id key should exist.")
    window_id = ENV[WebConsole::SPLIT_ID_KEY]
    assert(!window_id.is_integer?, "The split id should not be an integer.")
  end

  def test_window_id_key
    assert(ENV.has_key?(WebConsole::WINDOW_ID_KEY), "The window id key should exist.")
    window_id = ENV[WebConsole::WINDOW_ID_KEY]
    assert(window_id.is_integer?, "The window id should be an integer.")
    assert(window_id.to_i > 0, "The window id should be greater than zero.")
  end

  def test_shared_resources_path_key
    assert(ENV.has_key?(WebConsole::SHARED_RESOURCES_PATH_KEY), "The shared resources path key should exist.")
    resource_path = ENV[WebConsole::SHARED_RESOURCES_PATH_KEY]
    test_file = File.join(resource_path, TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end

  require 'open-uri'
  def test_shared_resources_url_key
    assert(ENV.has_key?(WebConsole::SHARED_RESOURCES_URL_KEY), "The shared resources url key should exist.")
    resource_url = ENV[WebConsole::SHARED_RESOURCES_URL_KEY]
    test_url = URI.join(resource_url, TEST_SHARED_RESOURCE_PATH_COMPONENT)
    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_url_string = test_url.to_s
    test_url_string.sub!(%r{^file:}, '')
    test_url_string.sub!(%r{^//localhost}, '') # For 10.8
    test_file = URI.unescape(test_url_string)
    assert(File.file?(test_file), "The test file should exist.")
  end

end