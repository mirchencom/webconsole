#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require WEBCONSOLE_FILE

require_relative "../lib/controller"

class TestController < Test::Unit::TestCase

  def test_controller
    controller = WebConsole::Data::Controller.new
    controller.add_key_value(TEST_KEY, TEST_VALUE)
    result = controller.value_for_key(TEST_KEY)
    assert_equal(result, TEST_VALUE, "The result should equal the test value.")
    controller.view.close
  end

end