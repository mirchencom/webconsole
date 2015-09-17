#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"

require_relative '../bundle/bundler/setup'
require 'webconsole'
require 'webconsole/logger'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "lib/test_helper"

class TestPlugin < Test::Unit::TestCase
  MESSAGE_PREFIX = WebConsole::Logger::MESSAGE_PREFIX
  ERROR_PREFIX = WebConsole::Logger::ERROR_PREFIX

  def setup
    WebConsole::load_plugin(TEST_PLUGIN_PATH)
    window_id = WebConsole::run_plugin(TEST_PLUGIN_NAME, TEST_PLUGIN_PATH)
    @window = WebConsole::Window.new(window_id)
    @test_helper = WebConsole::Log::Tests::TestHelper.new(@window)
  end

  def teardown
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

  # Tests

  def test_log_title
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give the plugin time to finish running
    title = @window.do_javascript(TEST_TITLE_JAVASCRIPT)
    title.chomp!
    assert_equal(title, TEST_PLUGIN_NAME, "The title should equal the test html title.")
  end

  def test_log

    # Test Error
    message = "Testing log error"
    input = ERROR_PREFIX + message
    @window.read_from_standard_input(input + "\n")
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("error", test_class, "The classes should match")

    # Test Message
    message = "Testing log message"
    input = MESSAGE_PREFIX + message
    @window.read_from_standard_input(input + "\n")
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("message", test_class, "The classes should match")

    # Test No Prefix
    @window.read_from_standard_input("Testing no prefix" + "\n")
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("message", test_class, "The classes should match")

    # Test Blank Spaces
    @window.read_from_standard_input("  \t" + "\n")
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("message", test_class, "The classes should match")

    # Test Empty String
    @window.read_from_standard_input("" + "\n")
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("message", test_class, "The classes should match")

  end

end
