#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "../lib/webconsole"
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestWebConsoleProperties < Test::Unit::TestCase

  def test_window_id
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    
    # Test the window_id is nil before running the plugin
    assert(!WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should not have a window.")
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id, "The window_id should be nil")

    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should have a window.")
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)

    window = WebConsole::Window.new(window_id)
    window.close

    # Test the window_id is nil after closing the window
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id, "The window_id should be nil")
    assert(!WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should not have a window.")
  end

  def test_exists
    exists = WebConsole::application_exists
    assert(exists, "The Web Console application should exist.")
  end

  # Shared Resources

  SHAREDRESOURCESPLUGIN_NAME = "Shared Resources"
  def test_resource_path_for_plugin
    resource_path = WebConsole::resource_path_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_file = File.join(resource_path, WebConsole::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end

  def test_shared_resources_path
    resource_path = WebConsole::shared_resources_path
    test_file = File.join(resource_path, WebConsole::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end
  SHARED_TEST_RESOURCE_PATH_COMPONENT = "ruby/test_constants.rb"
  def test_shared_test_resources_path
    resource_path = WebConsole::shared_test_resources_path
    test_file = File.join(resource_path, SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end

  def test_shared_resource
    resource_path = WebConsole::shared_resource(WebConsole::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  def test_shared_test_resource
    resource_path = WebConsole::shared_test_resource(SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  
  require 'open-uri'
  def test_resource_url
    resource_url = WebConsole::resource_url_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_url = URI.join(resource_url, WebConsole::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)

    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_url_string = test_url.to_s
    test_url_string.sub!(%r{^file:}, '')
    test_url_string.sub!(%r{^//localhost}, '') # For 10.8
    test_file = URI.unescape(test_url_string)

    assert(File.file?(test_file), "The test file should exist.")
  end
  def test_shared_resources_url
    resource_url = WebConsole::shared_resources_url
    test_url = URI.join(resource_url, WebConsole::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)

    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_url_string = test_url.to_s
    test_url_string.sub!(%r{^file:}, '')
    test_url_string.sub!(%r{^//localhost}, '') # For 10.8
    test_file = URI.unescape(test_url_string)

    assert(File.file?(test_file), "The test file should exist.")
  end
end

class TestWebConsoleRunPlugin < Test::Unit::TestCase

  def teardown
    @window.close
  end

  def test_run_plugin
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should have a window.")

    # Clean up
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    @window = WebConsole::Window.new(window_id)
  end

  def test_run_plugin_in_directory_with_arguments
    arguments = "1 2 3"    
    path = File.expand_path(TEST_DATA_DIRECTORY)

    WebConsole::load_plugin(DATA_PLUGIN_FILE)
    WebConsole::run_plugin(DATA_PLUGIN_NAME, path, arguments.split(" "))    
    window_id = WebConsole::window_id_for_plugin(DATA_PLUGIN_NAME)
    @window = WebConsole::Window.new(window_id)

    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give time for script to run

    path_result = @window.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_PATH_KEY}');])
    arguments_result = @window.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');])
    path_result.chomp!
    arguments_result.chomp!

    assert_equal(path_result, path, "The path result should match the path.")
    assert_equal(arguments_result, arguments, "The arguments result should match the arguments.")
  end

end

