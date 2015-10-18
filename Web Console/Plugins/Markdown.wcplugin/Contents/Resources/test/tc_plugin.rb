#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative '../bundle/bundler/setup'
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestPlugin < Test::Unit::TestCase

  def setup
    WebConsole::load_plugin(TEST_PLUGIN_PATH)
  end

  def teardown
    # window.close
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

  def test_load_markdown_file
    WebConsole::run_plugin(TEST_PLUGIN_NAME, TEST_PLUGIN_PATH, [TEST_MARKDOWN_FILE])

    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give the plugin time to finish running

    window_id = WebConsole::window_id_for_plugin(TEST_PLUGIN_NAME)
    window = WebConsole::Window.new(window_id)

    header = window.do_javascript(TEST_H1_JAVASCRIPT)
    assert_equal(header, TEST_MARKDOWN_HEADER, "The title should equal the test html title.")
  end

  # TODO Pass to stdin of plugin and test its title
  # def test_load_markdown_from_stdin
  #   markdown = File.read(TEST_MARKDOWN_FILE)
  #   WebConsole::plugin_read_from_standard_input(TEST_PLUGIN_NAME, markdown)
  # end

  # TODO Test changes to the Markdown files are updated

end


