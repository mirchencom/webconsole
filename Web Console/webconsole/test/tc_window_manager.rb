#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE
require CONSTANTS_FILE
require WebConsole::MODULE_FILE
require WebConsole::WINDOW_MANAGER_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WC_TEST_HELPER_FILE

class TestWindowManagerClose < Test::Unit::TestCase

  HELLOWORLDPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "HelloWorld.bundle")
  HELLOWORLDPLUGIN_NAME = "HelloWorld"
  def test_close
    WebConsole::load_plugin(HELLOWORLDPLUGIN_PATH)
    WebConsole::run_plugin(HELLOWORLDPLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(HELLOWORLDPLUGIN_NAME), "The plugin should have a window.")
    window_id = WebConsole::window_id_for_plugin(HELLOWORLDPLUGIN_NAME)
    @window_manager = WebConsole::WindowManager.new(window_id)
    @window_manager.close
    assert(!WebConsole::plugin_has_windows(HELLOWORLDPLUGIN_NAME), "The plugin should not have a window.")
  end

end

class TestWindowManagerDoJavaScript < Test::Unit::TestCase

  TESTHTML_FILE = File.join(TEST_DATA_DIRECTORY, "index.html")
  def setup
    html = File.read(TESTHTML_FILE)
    @window_manager = WebConsole::WindowManager.new
    @window_manager.load_html(html)
  end

  def teardown
    @window_manager.close
  end

  SIMPLEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "nodom.js")
  def test_do_javascript
    javascript = File.read(SIMPLEJAVASCRIPT_FILE)
    result = @window_manager.do_javascript(javascript)
    expected = WebConsole::TestHelper::run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i, "The result should match expected result.")
  end
end

class TestWindowManagerLoadHTML < Test::Unit::TestCase
  def setup
    @window_manager = WebConsole::WindowManager.new
  end

  def teardown
    @window_manager.close
  end

  TESTJAVASCRIPTBODY_FILE = File.join(TEST_DATA_DIRECTORY, "body.js")
  def test_load_html
    test_text = "This is a test string"
    html = "<html><body>" + test_text + "</body></html>"
    @window_manager.load_html(html)

    javascript = File.read(TESTJAVASCRIPTBODY_FILE)
    result = @window_manager.do_javascript(javascript)

    result.strip! # Remove line break
    assert_equal(test_text, result, "The result should match the test string.")
  end
end

class TestWindowManagerLoadHTMLWithBaseURL < Test::Unit::TestCase
  TESTHTMLJQUERY_FILE = File.join(TEST_DATA_DIRECTORY, "indexjquery.html")
  def setup
    html = File.read(TESTHTMLJQUERY_FILE)
    @window_manager = WebConsole::WindowManager.new
    @window_manager.base_url_path = File.expand_path(File.dirname(TESTHTMLJQUERY_FILE))
    @window_manager.load_html(html)
  end

  def teardown
    @window_manager.close
  end

  TESTJAVASCRIPTTEXTJQUERY_FILE = File.join(TEST_DATA_DIRECTORY, "textjquery.js")
  TESTJAVASCRIPTTEXT_FILE = File.join(TEST_DATA_DIRECTORY, "text.js")
  def test_load_with_base_url
    javascript = File.read(TESTJAVASCRIPTTEXTJQUERY_FILE)
    result = @window_manager.do_javascript(javascript)

    test_javascript = File.read(TESTJAVASCRIPTTEXT_FILE)
    expected = @window_manager.do_javascript(test_javascript)

    assert_equal(expected, result, "The result should equal expected result.")
  end

end

# TODO The Web Console functionality for the below test doesn't exist yet. The Web Console API first needs to be able to target reading from standard input for a specific window manager before this test will be possible.

class TestTwoWindowManagers < Test::Unit::TestCase
  PRINTPLUGIN_PATH = File.join(TEST_DATA_DIRECTORY, "Print.bundle")
  PRINTPLUGIN_NAME = "Print"
  def setup
    WebConsole::load_plugin(PRINTPLUGIN_PATH)
  end
  
  def teardown
    @window_manager_one.close
    WebConsole::TestHelper::confirm_dialog
  
    @window_manager_two.close
    WebConsole::TestHelper::confirm_dialog
  end

  LASTCODEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "lastcode.js")
  def test_two_window_managers
    # test_text_one = "The first test string"
    # test_text_two = "The second test string"

    # Window Manager One
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    window_id_one = WebConsole::window_id_for_plugin(PRINTPLUGIN_NAME)
    @window_manager_one = WebConsole::WindowManager.new(window_id_one)
    # WebConsole::plugin_read_from_standard_input(PRINTPLUGIN_NAME, test_text_one + "\n")
    # sleep PAUSE_TIME # Give read from standard input time to run

    # Window Manager Two
    WebConsole::run_plugin(PRINTPLUGIN_NAME)
    window_id_two = WebConsole::window_id_for_plugin(PRINTPLUGIN_NAME)
    @window_manager_two = WebConsole::WindowManager.new(window_id_two)
    # WebConsole::plugin_read_from_standard_input(PRINTPLUGIN_NAME, test_text_two + "\n")
    # sleep PAUSE_TIME # Give read from standard input time to run

    # TODO This test doesn't really work because plugin_read_from_standard_input can't target a unique window_manager, finish this test when that functionality exists. For now the only thing valid to test is that the window ids are different.

    assert_not_equal(window_id_one, window_id_two, "Window managers one and two should have different window ids.")

    # TODO Switch the window order of window manager's one and two

    # javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    # 
    # # Window Manager One
    # result_one = @window_manager_one.do_javascript(javascript)
    # result_one.strip!
    # 
    # # Window Manager Two
    # result_two = @window_manager_two.do_javascript(javascript)
    # result_two.strip!
    # 
    # assert_equal(test_text_one, result_one, "The first test text should equal the first result.")
    # assert_equal(test_text_two, result_two, "The second test text should equal the second result.")
  end
end