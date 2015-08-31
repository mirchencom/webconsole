#!/usr/bin/env ruby

require "test/unit"

require_relative '../bundle/bundler/setup'
require 'webconsole'

require_relative "lib/test_helper"

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "../lib/view"

class TestView < Test::Unit::TestCase

  def setup
    @view = WebConsole::Log::View.new
    @test_helper = WebConsole::Log::Tests::TestHelper.new(@view)
  end
  
  def teardown
    @view.close
  end

  def test_javascript
    # Test Error
    message = "Testing log error"
    @view.log_error(message)
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("error", test_class, "The classes should match")

    # Test Warning
    message = "Testing log warning"
    @view.log_warning(message)
    test_message = @test_helper.last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_helper.last_log_class()
    assert_equal("warning", test_class, "The classes should match")
  end

end
