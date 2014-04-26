#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "../lib/webconsole"
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestWebConsoleProperties < Test::Unit::TestCase

  def test_window_id
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should have a window.")

    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window_manager = WebConsole::WindowManager.new(window_id)
    window_manager.close

    assert(!WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should not have a window.")
  end

  # Shared Resources

  SHAREDRESOURCESPLUGIN_NAME = "Shared Resources"
  SHARED_RESOURCE_PLUGIN_PATH_COMPONENT = "js/zepto.js"
  def test_resource_path_for_plugin
    resource_path = WebConsole::resource_path_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_file = File.join(resource_path, SHARED_RESOURCE_PLUGIN_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end
  SHARED_RESOURCE_PATH_COMPONENT = "js/zepto.js"
  def test_shared_resources_path
    resource_path = WebConsole::shared_resources_path
    test_file = File.join(resource_path, SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end
  SHARED_TEST_RESOURCE_PATH_COMPONENT = "ruby/test_constants.rb"
  def test_shared_test_resources_path
    resource_path = WebConsole::shared_test_resources_path
    test_file = File.join(resource_path, SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end

  def test_shared_resource
    resource_path = WebConsole::shared_resource(SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  def test_shared_test_resource
    resource_path = WebConsole::shared_test_resource(SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  
  require 'open-uri'
  def test_resource_url
    resource_url = WebConsole::resource_url_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_url = URI.join(resource_url, SHARED_RESOURCE_PLUGIN_PATH_COMPONENT)

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
    test_url = URI.join(resource_url, SHARED_RESOURCE_PATH_COMPONENT)

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
    @window_manager.close
  end

  def test_run_plugin
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should have a window.")

    # Clean up
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)
  end

  def test_run_plugin_in_directory_with_arguments
    arguments = "1 2 3"    
    path = File.expand_path(TEST_DATA_DIRECTORY)

    WebConsole::load_plugin(DATA_PLUGIN_FILE)
    WebConsole::run_plugin(DATA_PLUGIN_NAME, path, arguments.split(" "))    
    window_id = WebConsole::window_id_for_plugin(DATA_PLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)

    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give time for script to run

    path_result = @window_manager.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_PATH_KEY}');])
    arguments_result = @window_manager.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');])
    path_result.chomp!
    arguments_result.chomp!

    assert_equal(path_result, path, "The path result should match the path.")
    assert_equal(arguments_result, arguments, "The arguments result should match the arguments.")
  end

end

class TestWebConsolePluginReadFromStandardInput < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(WebConsole::Tests::PRINT_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)
  end
  
  def teardown
    @window_manager.close
    WebConsole::Tests::Helper::confirm_dialog
  end

  def test_plugin_read_from_standard_input
    test_text = "This is a test string"
    WebConsole::plugin_read_from_standard_input(WebConsole::Tests::PRINT_PLUGIN_NAME, test_text + "\n")
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give read from standard input time to run

    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end
end
