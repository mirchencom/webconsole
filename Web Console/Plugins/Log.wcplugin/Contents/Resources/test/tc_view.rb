#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "../lib/view"

class TestPlugin < Test::Unit::TestCase

  def setup
    @view = WebConsole::Log::View.new
  end
  
  def teardown
    @view.close
  end

  def test_view
    # Test Error
    message = "Testing log error"
    log_error(message)
    test_message = last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = last_log_class()
    assert_equal("error", test_class, "The classes should match")

    # Test Warning
    message = "Testing log warning"
    log_warning(message)
    test_message = last_log_message()
    assert_equal(message, test_message, "The messages should match")
    test_class = last_log_class()
    assert_equal("warning", test_class, "The classes should match")
  end

  # Helper

  def last_log_class()
    result = @view.do_javascript(TEST_CLASS_JAVASCRIPT)
    return result.chomp
  end

  def last_log_message()
    result = @view.do_javascript(TEST_MESSAGE_JAVASCRIPT)
    return result.chomp
  end

  def log_error(message)
    javascript = WebConsole::View::javascript_function("error", [message])
    @view.do_javascript(javascript)
  end

  def log_warning(message)
    javascript = WebConsole::View::javascript_function("warning", [message])
    @view.do_javascript(javascript)
  end

end
