#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'

require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestResizing < Test::Unit::TestCase
  WINDOWBOUNDS = "120, 230, 700, 500"
  WINDOWBOUNDSTWO = "150, 200, 600, 600"
  def test_resizing
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    
    bounds = WebConsole::Tests::Helper::window_bounds

    if bounds.size_matches(WINDOWBOUNDS)
      destination_bounds = WINDOWBOUNDS
      destination_bounds_two = WINDOWBOUNDSTWO
    else
      destination_bounds = WINDOWBOUNDSTWO
      destination_bounds_two = WINDOWBOUNDS
    end

    WebConsole::Tests::Helper::set_window_bounds(destination_bounds)

    # Close the window
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window = WebConsole::Window.new(window_id)
    window.close

    # Open a new window, the new window's size should match destination bounds
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    bounds = WebConsole::Tests::Helper::window_bounds
    assert(bounds.size_matches(destination_bounds), "The windows bounds should match the destination bounds.")

    # Quit
    WebConsole::Tests::Helper::quit
    sleep WebConsole::Tests::TEST_PAUSE_TIME

    # Open a new window, the new window's size should match the destination bounds
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    bounds = WebConsole::Tests::Helper::window_bounds
    assert(bounds.size_matches(destination_bounds), "The windows bounds should match the destination bounds.")
        
    # Open a second window, the second window's size should match the destination bounds
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window_id_two = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert_not_equal(window_id, window_id_two, "The second window's identifier should not match the first window's identifier.")
    bounds = WebConsole::Tests::Helper::window_bounds(window_id_two)
    assert(bounds.size_matches(destination_bounds), "The windows bounds should match the destination bounds.")

    # Resize the second window to destination bounds two
    WebConsole::Tests::Helper::set_window_bounds(destination_bounds_two)    
    
    # Open a third window, the third window's size should match destination bounds two
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window_id_three = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert_not_equal(window_id, window_id_two, "The third window's identifier should not match the second window's identifier.")    
    bounds = WebConsole::Tests::Helper::window_bounds(window_id_three)
    assert(bounds.size_matches(destination_bounds_two), "The third windows bounds should match the second destination bounds.")
    
    # Quit
    WebConsole::Tests::Helper::quit
    sleep WebConsole::Tests::TEST_PAUSE_TIME
    
    # Open a window, the window's size should match destination bounds two
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    bounds = WebConsole::Tests::Helper::window_bounds
    assert(bounds.size_matches(destination_bounds_two), "The windows bounds should match the destination bounds.")
    
    # Cleanup
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window = WebConsole::Window.new(window_id)
    window.close
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
