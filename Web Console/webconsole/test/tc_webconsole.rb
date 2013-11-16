#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
WEBCONSOLE_FILE = File.join(SCRIPT_DIRECTORY, "..", "lib", "webconsole")
require WEBCONSOLE_FILE
DATA_DIRECTORY = File.join(SCRIPT_DIRECTORY, "data")

module WebConsoleTestsHelper
  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end

  RESPONDTODIALOGAPPLESCRIPT_FILE = File.join(DATA_DIRECTORY, "respond_to_dialog.scpt")
  def self.respond_to_dialog
    `osascript #{Shellwords.escape(RESPONDTODIALOGAPPLESCRIPT_FILE)}`
  end
end

# WebConsole

class TestRunPlugin < Test::Unit::TestCase
  HELLOWORLDPLUGIN_PATH = File.join(DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_run_plugin
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(HELLOWORLDPLUGIN_NAME), "The plugin should have a window.")

    # Clean up
    window_id = WebConsole::window_id_for_plugin(HELLOWORLDPLUGIN_NAME)
    window_manager = WebConsole::WindowManager.new(window_id)
    window_manager.close
  end

  PRINTPLUGIN_PATH = File.join(DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  LASTCODEJAVASCRIPT_FILE = File.join(DATA_DIRECTORY, "lastcode.js")
  def test_read_from_standard_input_plugin
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(PRINTPLUGIN_NAME), "The plugin should have a window.")

    test_text = "This is a test string"
    WebConsole::plugin_read_from_standard_input(PRINTPLUGIN_NAME, test_text + "\n")
    sleep 0.5 # Give read from standard input time to run

    window_id = WebConsole::window_id_for_plugin(PRINTPLUGIN_NAME)
    window_manager = WebConsole::WindowManager.new(window_id)

    javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    result = window_manager.do_javascript(javascript)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")

    # Clean up
    window_manager.close
    WebConsoleTestsHelper::respond_to_dialog
  end
end


# WindowManager

class TestDoJavaScript < Test::Unit::TestCase

  TESTHTML_FILE = File.join(DATA_DIRECTORY, "index.html")
  def setup
    html = File.read(TESTHTML_FILE)
    @window_manager = WebConsole::WindowManager.new
    @window_manager.load_html(html)
  end

  def teardown
    @window_manager.close
  end

  SIMPLEJAVASCRIPT_FILE = File.join(DATA_DIRECTORY, "nodom.js")
  def test_do_javascript
    javascript = File.read(SIMPLEJAVASCRIPT_FILE)
    result = @window_manager.do_javascript(javascript)
    expected = WebConsoleTestsHelper::run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i, "The result should match expected result.")
  end
end

class TestLoadHTML < Test::Unit::TestCase
  def setup
    @window_manager = WebConsole::WindowManager.new
  end

  def teardown
    @window_manager.close
  end

  TESTJAVASCRIPTBODY_FILE = File.join(DATA_DIRECTORY, "body.js")
  def test_load_html
    test_text = "This is a test string"
    html = "<html><body>" + test_text + "</body></html>"
    @window_manager.load_html(html)

    javascript = File.read(TESTJAVASCRIPTBODY_FILE)
    result = @window_manager.do_javascript(javascript)

    result.strip! # Remove line break
    assert_equal(test_text, result, "The result should match the test string.")
  end
end

class TestLoadHTMLWithBaseURL < Test::Unit::TestCase
  TESTHTMLJQUERY_FILE = File.join(DATA_DIRECTORY, "indexjquery.html")
  def setup
    html = File.read(TESTHTMLJQUERY_FILE)
    @window_manager = WebConsole::WindowManager.new
    @window_manager.base_url_path = File.expand_path(File.dirname(TESTHTMLJQUERY_FILE))
    @window_manager.load_html(html)
  end

  def teardown
    @window_manager.close
  end

  TESTJAVASCRIPTTEXTJQUERY_FILE = File.join(DATA_DIRECTORY, "textjquery.js")
  TESTJAVASCRIPTTEXT_FILE = File.join(DATA_DIRECTORY, "text.js")
  def test_load_from_base_url
    javascript = File.read(TESTJAVASCRIPTTEXTJQUERY_FILE)
    result = @window_manager.do_javascript(javascript)

    test_javascript = File.read(TESTJAVASCRIPTTEXT_FILE)
    expected = @window_manager.do_javascript(test_javascript)

    assert_equal(expected, result, "The result should equal expected result.")
  end
end
