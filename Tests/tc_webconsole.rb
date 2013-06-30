#!/usr/bin/env ruby

require "test/unit"
SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
WEBCONSOLE_FILE = File.join(SCRIPT_DIRECTORY, "WebConsole", "WebConsole")
require WEBCONSOLE_FILE

class TestWebConsole < Test::Unit::TestCase
  def test_load_html
    webconsole = WebConsole.new

    html = "test"
    webconsole.load_html(html)
    webconsole.close
  end
end

