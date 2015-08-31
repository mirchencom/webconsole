#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "../lib/controller"

class TestView < Test::Unit::TestCase
  MESSAGE_PREFIX = WebConsole::Logger::MESSAGE_PREFIX
  ERROR_PREFIX = WebConsole::Logger::ERROR_PREFIX

  def setup
    @controller = WebConsole::Log::Controller.new
  end
  
  def teardown
    # @controller.view.close
  end

  def test_controller
    message = MESSAGE_PREFIX + "Testing log error"
    @controller.parse_input(message)
    message = ERROR_PREFIX + "Testing log error"
    @controller.parse_input(message)

    # TODO Should do nothing if the prefix doesn't match
    # TODO Assert blank lines do nothing
  end

  # Helper

  def last_log_class()
    result = @controller.view.do_javascript(TEST_CLASS_JAVASCRIPT)
    return result.chomp
  end

end