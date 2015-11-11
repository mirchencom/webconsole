#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestQuitWithRunningTask < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(WebConsole::Tests::TESTLOG_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::TESTLOG_PLUGIN_NAME)

    sleep WebConsole::Tests::TEST_PAUSE_TIME # Let plugin run
  end

  # def teardown
  #   WebConsole::Tests::Helper::quit
  #   WebConsole::Tests::Helper::confirm_dialog
  # end

  def test_log
  end

end