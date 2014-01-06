#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require CONTROLLER_FILE

class TestWebConsoleProperties < Test::Unit::TestCase

  TESTJAVASCRIPTTEXTJQUERY_FILE = File.join(TEST_DATA_DIRECTORY, "textjquery.js")
  TESTJAVASCRIPTTEXT_FILE = File.join(TEST_DATA_DIRECTORY, "text.js")

  def test_controller
    window_manager = WebConsole::WindowManager.new
    controller = WebConsole::Controller.new(window_manager, TEST_TEMPLATE_FILE)

    # Testing jquery assures that `zepto.js` has been loaded correctly
    javascript = File.read(TESTJAVASCRIPTTEXTJQUERY_FILE)
    result = window_manager.do_javascript(javascript)

    test_javascript = File.read(TESTJAVASCRIPTTEXT_FILE)
    expected = window_manager.do_javascript(test_javascript)

    assert_equal(expected, result, "The result should equal expected result.")
  end


  def test_controller_with_environment_variable  
    # Test that when the WC_SHARED_RESOURCES_URL_KEY environment variable is already set, that web console does not need to be launched in order to 
    # Also make sure the delegate is nil so delegate methods don't launch 
    # ENV[WC_SHARED_RESOURCES_URL_KEY] = WebConsole::shared_resources_url.to_s
    # Quit web console
    # Make sure delegate is nil
    # Should not launch web console
  end

end