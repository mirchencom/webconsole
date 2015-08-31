#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "../lib/view"

class TestView < Test::Unit::TestCase

  def setup
    @controller = WebConsole::Log::View.new
  end
  
  def teardown
    # @controller.view.close
  end

  def test_javascript
  end

  # Helper

  def last_log_class()
    result = @controller.view.do_javascript(TEST_CLASS_JAVASCRIPT)
    return result.chomp
  end

end