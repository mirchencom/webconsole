#!/usr/bin/env ruby

require "test/unit"

require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "lib/test_constants"

class TestPlugin < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(TEST_PLUGIN_PATH)
  end

  def teardown
    # window.close
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

  def test_plugin
    WebConsole::run_plugin(TEST_PLUGIN_NAME, TEST_PLUGIN_PATH)

    window_id = WebConsole::window_id_for_plugin(TEST_PLUGIN_NAME)
    window = WebConsole::Window.new(window_id)
    
    test_code = TEST_CODE.gsub("\n", "\uFF00") + "\n"
    window.read_from_standard_input(test_code)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed

    # Test Wrapper Input
    javascript = File.read(WebConsole::Tests::FIRSTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    result.strip!
    result.gsub!(/<\/?span.*?>/, "") # Remove spans adding by highlight.js
    assert_equal(TEST_CODE, result, "The test text should equal the result.")

    # Test Wrapper Output
    javascript = File.read(WebConsole::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    assert_equal(result, TEST_CODE_RESULT, "The test result should equal the result.")
  end

end
