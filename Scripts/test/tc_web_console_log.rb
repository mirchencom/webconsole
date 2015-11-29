#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

# Helper

def inner_text_at_index(index)
  javascript = "document.getElementsByTagName(\"p\")[#{index.to_i}].innerText;"
  @log_view.do_javascript(javascript).chomp
end

def class_at_index(index)
  javascript = "document.getElementsByTagName(\"p\")[#{index.to_i}].className;"
  @log_view.do_javascript(javascript).chomp
end

class TestLog < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(WebConsole::Tests::TESTLOG_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::TESTLOG_PLUGIN_NAME)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Let plugin run

    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::TESTLOG_PLUGIN_NAME)
    view_id = WebConsole::split_id_in_window_last(window_id)
    @log_view = WebConsole::View.new(window_id, view_id)
  end

  def teardown
    WebConsole::Tests::Helper::quit
  end

  def test_log
    assert_equal(inner_text_at_index(0), "Running: test_log.rb")
    assert_equal(class_at_index(0), "message")
    assert_equal(inner_text_at_index(1), "Testing log message")
    assert_equal(class_at_index(1), "message")
    assert_equal(inner_text_at_index(2), "Testing print to standard error")
    assert_equal(class_at_index(2), "error")
    assert_equal(inner_text_at_index(3), "Testing print to standard input")
    assert_equal(class_at_index(3), "message")
    assert_equal(inner_text_at_index(4), "Do JavaScript: document.body.innerHTML = \"test\";")
    assert_equal(class_at_index(4), "message")
    assert_equal(inner_text_at_index(5), "Testing log error")
    assert_equal(class_at_index(5), "error")
    assert_equal(inner_text_at_index(6), "Finished running: test_log.rb")
    assert_equal(class_at_index(6), "message")
  end

end


class TestInvalidLog < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(WebConsole::Tests::INVALID_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::INVALID_PLUGIN_NAME)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Let plugin run

    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::INVALID_PLUGIN_NAME)
    view_id = WebConsole::split_id_in_window_last(window_id)
    @log_view = WebConsole::View.new(window_id, view_id)
  end

  def teardown
    WebConsole::Tests::Helper::quit
  end

  def test_invalid_log
    assert_equal(inner_text_at_index(0), "Failed to run: invalid path")
    assert_equal(class_at_index(0), "error")
    assert(inner_text_at_index(1).start_with? "Error: Command path is not executable:")
    assert_equal(class_at_index(1), "error")
  end

end