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

    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::TESTLOG_PLUGIN_NAME)
    view_id = WebConsole::split_id_in_window_last(window_id)
    @log_view = WebConsole::View.new(window_id, view_id)
  end

  # def teardown
  #   WebConsole::Tests::Helper::quit
  #   WebConsole::Tests::Helper::confirm_dialog
  # end

  def test_log
    text = inner_text_at_index(0)
puts "text = " + text.to_s

  end

  def inner_text_at_index(index)
    javascript = "document.getElementsByTagName(\"p\")[#{index.to_i}].innerText;"
    @log_view.do_javascript(javascript)
  end

  def class_at_index(index)
    javascript = "document.getElementsByTagName(\"p\")[#{index.to_i}].className;"
    @log_view.do_javascript(javascript)
  end

end