#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/window"
require_relative "lib/test_constants"

class TestController < Test::Unit::TestCase

  def test_controller
    window = Window.new
    window.load_html(TEST_HTML)
    window.close
  end

end
