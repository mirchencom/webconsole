#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require CONSTANTS_FILE
require WebConsole::MODULE_FILE
require WebConsole::WINDOW_MANAGER_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WC_TEST_HELPER_FILE

class TestWebConsoleProperties < Test::Unit::TestCase

  HELLOWORLDPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_window_id
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(HELLOWORLDPLUGIN_NAME), "The plugin should have a window.")

    window_id = WebConsole::window_id_for_plugin(HELLOWORLDPLUGIN_NAME)
    window_manager = WebConsole::WindowManager.new(window_id)
    window_manager.close

    assert(!WebConsole::plugin_has_windows(HELLOWORLDPLUGIN_NAME), "The plugin should not have a window.")
  end

  SHAREDRESOURCESPLUGIN_NAME = "Shared Resources"
  WEB_CONSOLE_CONSTANTS_PATH_COMPONENT = "Shared/js/zepto.js"
  def test_resource_path
    resource_path = WebConsole::resource_path_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_file = File.join(resource_path, WEB_CONSOLE_CONSTANTS_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end
  SHARED_RESOURCE_PATH_COMPONENT = "js/zepto.js"
  def test_shared_resources_path
    resource_path = WebConsole::shared_resources_path
    test_file = File.join(resource_path, SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end
  SHARED_TEST_RESOURCE_PATH_COMPONENT = "ruby/test_constants.rb"
  def test_shared_resources_path
    resource_path = WebConsole::shared_test_resource(SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  
  require 'open-uri'
  def test_resource_url
    resource_url = WebConsole::resource_url_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_url = URI.join(resource_url, WEB_CONSOLE_CONSTANTS_PATH_COMPONENT)

    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_file = URI.unescape(test_url.to_s.sub!(%r{^file://localhost}, ''))
    assert(File.file?(test_file), "The test file should exist.")
  end
  def test_shared_resources_url
    resource_url = WebConsole::shared_resources_url
    test_url = URI.join(resource_url, SHARED_RESOURCE_PATH_COMPONENT)

    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_file = URI.unescape(test_url.to_s.sub!(%r{^file://localhost}, ''))
    assert(File.file?(test_file), "The test file should exist.")
  end
end

class TestWebConsoleRunPlugin < Test::Unit::TestCase

  def teardown
    @window_manager.close
  end

  HELLOWORLDPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_run_plugin
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(HELLOWORLDPLUGIN_NAME), "The plugin should have a window.")

    # Clean up
    window_id = WebConsole::window_id_for_plugin(HELLOWORLDPLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)
  end

  DATAPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "Data.bundle")
  DATAPLUGIN_NAME = "Data"
  PATH_KEY = "Path"
  ARGUMENTS_KEY = "Arguments"
  def test_run_plugin_in_directory_with_arguments
    arguments = "1 2 3"    
    path = File.expand_path(TEST_DATA_DIRECTORY)

    WebConsole::load_plugin(DATAPLUGIN_PATH)
    WebConsole::run_plugin(DATAPLUGIN_NAME, path, arguments.split(" "))    
    window_id = WebConsole::window_id_for_plugin(DATAPLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)

    sleep WC_TEST_PAUSE_TIME # Give time for script to run

    path_result = @window_manager.do_javascript(%Q[valueForKey('#{PATH_KEY}');])
    arguments_result = @window_manager.do_javascript(%Q[valueForKey('#{ARGUMENTS_KEY}');])
    path_result.chomp!
    arguments_result.chomp!

    assert_equal(path_result, path, "The path result should match the path.")
    assert_equal(arguments_result, arguments, "The arguments result should match the arguments.")
  end

end

class TestWebConsolePluginReadFromStandardInput < Test::Unit::TestCase

  PRINTPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  def setup
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    window_id = WebConsole::window_id_for_plugin(PRINTPLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)
  end
  
  def teardown
    @window_manager.close
    WebConsole::Tests::Helper::confirm_dialog
  end

  LASTCODEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "lastcode.js")
  def test_plugin_read_from_standard_input
    test_text = "This is a test string"
    WebConsole::plugin_read_from_standard_input(PRINTPLUGIN_NAME, test_text + "\n")
    sleep WC_TEST_PAUSE_TIME # Give read from standard input time to run

    javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    result = @window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end
end
