#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require TEST_HELPER_FILE


class TestResizing < Test::Unit::TestCase
  HELLOWORLDPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def setup
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
  end

  def test_quit_confirming_after_starting_short_second_task
    # WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    # 
    # bounds = TestsHelper::window_bounds
    # window_id = WebConsole::window_id_for_plugin(HELLOWORLDPLUGIN_NAME)
    # 
    # puts bounds
    # puts window_id

    TestsHelper::set_window_bounds("120, 230, 700, 500")
   
    # Move the window to a location

    # Have AppleScript set the windows bounds

    # tell application "Web Console"
    #   set the bounds of window 1 to {120, 230, 700, 500}
    # end tell

  end  

end