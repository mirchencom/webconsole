#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
WEBCONSOLE_FILE = File.join(SCRIPT_DIRECTORY, "..", "lib", "webconsole")
require WEBCONSOLE_FILE
DATA_DIRECTORY = File.join(SCRIPT_DIRECTORY, "data")

module JavaScriptHelper
  def self.run_javascript(javascript)
    return `node -e #{Shellwords.escape(javascript)}`
  end
end

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
    expected = JavaScriptHelper::run_javascript(javascript)
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
    testString = "This is a test string"
    html = "<html><body>" + testString + "</body></html>"
    @window_manager.load_html(html)

    javascript = File.read(TESTJAVASCRIPTBODY_FILE)
    result = @window_manager.do_javascript(javascript)

    result.strip! # Remove line break
    assert_equal(testString, result, "The result should match the test string.")
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
