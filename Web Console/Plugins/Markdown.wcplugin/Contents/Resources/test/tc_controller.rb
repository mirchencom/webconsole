#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

require_relative '../bundle/bundler/setup'
require 'webconsole'

require_relative "lib/test_constants"
require_relative "../lib/controller"

class TestController < Test::Unit::TestCase

  def test_controller
    markdown = File.read(TEST_MARKDOWN_FILE)
    filename = File.basename(TEST_MARKDOWN_FILE)
    
    controller = WebConsole::Markdown::Controller.new(markdown, filename)
    
    header = controller.view.do_javascript(TEST_H1_JAVASCRIPT)
    assert_equal(header, TEST_MARKDOWN_HEADER, "The header should equal the test html title.")
    
    markdown_two = File.read(TEST_MARKDOWN_FILE_TWO)
    controller.markdown = markdown_two
    header_two = controller.view.do_javascript(TEST_H1_JAVASCRIPT)
    header_two.chomp!

    assert_equal(header_two, TEST_MARKDOWN_HEADER_TWO, "The second header should equal the second test html title.")
    
    controller.view.close
  end

end