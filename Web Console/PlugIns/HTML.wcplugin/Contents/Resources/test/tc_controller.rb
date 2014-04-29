#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

require_relative '../bundle/bundler/setup'
require 'webconsole'

require_relative "lib/test_constants"
require_relative "../lib/controller"

class TestController < Test::Unit::TestCase

  def test_controller
    html = File.read(TEST_HTML_FILE)
    window_manager = WebConsole::WindowManager.new
    controller = WcHTML::Controller.new(window_manager, html)

    title = window_manager.do_javascript(TEST_TITLE_JAVASCRIPT)
    title.chomp!

    assert_equal(title, TEST_HTML_TITLE, "The title should equal the test html title.")

    html_two = File.read(TEST_HTML_FILE_TWO)
    controller.html = html_two
    title_two = window_manager.do_javascript(TEST_TITLE_JAVASCRIPT)
    title_two.chomp!
    
    assert_equal(title_two, TEST_HTML_TITLE_TWO, "The second title should equal the second test html title.")

    window_manager.close
  end

end