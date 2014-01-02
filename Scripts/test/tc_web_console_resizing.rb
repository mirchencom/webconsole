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

  WINDOWBOUNDS = "120, 230, 700, 500"
  WINDOWBOUNDSTWO = "150, 200, 600, 600"

  # Add methods to string in the context of this test class:
  # Search for escape_javaScript for how to contextually add a method to a string
  # WINDOWBOUNDS.height
  # WINDOWBOUNDS.width
  # WINDOWBOUNDS.size_matches(bounds)
  def test_quit_confirming_after_starting_short_second_task
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    
    bounds = TestsHelper::window_bounds

    puts bounds
    puts WINDOWBOUNDS
    puts WINDOWBOUNDS.height
    puts WINDOWBOUNDS.width
    puts WINDOWBOUNDS

    puts bounds.size_matches(WINDOWBOUNDS)
    puts bounds.size_matches(WINDOWBOUNDSTWO)

    TestsHelper::set_window_bounds(WINDOWBOUNDS)

    # Write a helper method to compare one bounds string to another, I just want to test that the sizes are accurate:
    # width = xend - xstart
    # height = yend - ystart
    # width1 == width2
    # height1 == height2
    
    # cascading offset equals 21 pixels horizontal and 23 pixels vertical

    # window_id = WebConsole::window_id_for_plugin(HELLOWORLDPLUGIN_NAME)
  end

  class ::String
    def height
      bounds = self.split(",")
      return bounds[3].to_i - bounds[1].to_i
    end

    def width
      bounds = self.split(",")
      return bounds[2].to_i - bounds[0].to_i
    end

    def size_matches(bounds)
      if self.width != bounds.width
        return false
      end

      if self.height != bounds.height
        return false
      end

      return true
    end
  end
end