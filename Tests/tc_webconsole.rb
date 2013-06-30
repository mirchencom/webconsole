#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
WEBCONSOLE_FILE = File.join(SCRIPT_DIRECTORY, "WebConsole", "WebConsole")
require WEBCONSOLE_FILE
DATA_DIRECTORY = File.join(File.dirname(__FILE__), "Data")

class TestWebConsole < Test::Unit::TestCase

  TESTHTML_FILE = File.join(DATA_DIRECTORY, "index.html")
  def setup
    html = File.read(TESTHTML_FILE)
    @webconsole = WebConsole.new
    @webconsole.load_html(html)
  end

  def teardown
    @webconsole.close
  end

  SIMPLEJAVASCRIPT_FILE = File.join(DATA_DIRECTORY, "SimpleJavaScript.js")
  def test_do_javascript
    javascript = File.read(SIMPLEJAVASCRIPT_FILE)
    result = @webconsole.do_javascript(javascript)
    expected = `node #{Shellwords.escape(SIMPLEJAVASCRIPT_FILE)}`
    assert_equal(expected.to_i, result.to_i, "Expected doesn't match result")
  end

  # def test_load_html
  #   # Test result of do javascript
  # end
end

