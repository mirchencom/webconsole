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
    assert_equal(expected.to_i, result.to_i, "Result doesn't match expected.")
  end
end

class TestLoadHTML < Test::Unit::TestCase
  def setup
    @webconsole = WebConsole.new
  end

  def teardown
    @webconsole.close
  end

  def test_load_html
    testString = "This is a test string"
    html = "<html><body>" + testString + "</body></html>"
    javascript = "document.getElementsByTagName('body')[0].innerHTML;"
    @webconsole.load_html(html)
    result = @webconsole.do_javascript(javascript)
    result.strip! # Remove line break
    assert_equal(testString, result, "Result doesn't match test string.")
  end
end

class TestLoadHTMLWithBaseURL < Test::Unit::TestCase
  TESTHTMLJQUERY_FILE = File.join(DATA_DIRECTORY, "indexjquery.html")
  def setup
    html = File.read(TESTHTMLJQUERY_FILE)
    @webconsole = WebConsole.new
    @webconsole.base_url_path = File.expand_path(File.dirname(TESTHTMLJQUERY_FILE))
    @webconsole.load_html(html)
  end

  def teardown
    @webconsole.close
  end

  TESTJQUERYJAVASCRIPT_FILE = File.join(DATA_DIRECTORY, "JQueryJavaScript.js")
  def test_load_from_base_url
    javascript = File.read(TESTJQUERYJAVASCRIPT_FILE)
    result = @webconsole.do_javascript(javascript)
puts "result = " + result.to_s

  end
end