#!/usr/bin/env ruby

require "test/unit"

require_relative "../lib/controller"

class TestController < Test::Unit::TestCase

  def test_controller
    controller = WcData::Controller.new
    controller.add_key_value("Arguments", "1 2 3")
  end

end