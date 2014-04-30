#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "../lib/webconsole"
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

class TestWindowAttributes < Test::Unit::TestCase

  def test_window_id
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should have a window.")
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window = WebConsole::Window.new(window_id)
    assert(window_id == window.window_id, "The window id's should be equal.")
    window.close
  end

end


class TestWindowClose < Test::Unit::TestCase

  def test_close
    WebConsole::load_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_FILE)
    WebConsole::run_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should have a window.")
    window_id = WebConsole::window_id_for_plugin(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME)
    window = WebConsole::Window.new(window_id)
    window.close
    assert(!WebConsole::plugin_has_windows(WebConsole::Tests::HELLOWORLD_PLUGIN_NAME), "The plugin should not have a window.")
  end

end

class TestWindowDoJavaScript < Test::Unit::TestCase

  def setup
    html = File.read(WebConsole::Tests::INDEX_HTML_FILE)
    @window = WebConsole::Window.new
    @window.load_html(html)
  end

  def teardown
    @window.close
  end

  def test_do_javascript
    javascript = File.read(WebConsole::Tests::NODOM_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    expected = WebConsole::Tests::Helper::run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i, "The result should match expected result.")
  end
end

class TestWindowLoadHTML < Test::Unit::TestCase
  def setup
    @window = WebConsole::Window.new
  end

  def teardown
    @window.close
  end

  def test_load_html
    test_text = "This is a test string"
    html = "<html><body>" + test_text + "</body></html>"
    @window.load_html(html)


    javascript = File.read(WebConsole::Tests::BODY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)

    result.strip! # Remove line break
    assert_equal(test_text, result, "The result should match the test string.")
  end
end

class TestWindowLoadHTMLWithBaseURL < Test::Unit::TestCase
  def setup
    html = File.read(WebConsole::Tests::INDEXJQUERY_HTML_FILE)
    @window = WebConsole::Window.new
    @window.base_url_path = File.join(WebConsole::shared_resources_path)
    @window.load_html(html)
  end

  def teardown
    @window.close
  end

  def test_load_with_base_url
    javascript = File.read(WebConsole::Tests::TEXTJQUERY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)

    test_javascript = File.read(WebConsole::Tests::TEXT_JAVASCRIPT_FILE)
    expected = @window.do_javascript(test_javascript)

    assert_equal(expected, result, "The result should equal expected result.")
  end

end

# TODO The Web Console functionality for the below test doesn't exist yet. The Web Console API first needs to be able to target reading from standard input for a specific window manager before this test will be possible.

class TestTwoWindows < Test::Unit::TestCase
  def setup
    WebConsole::load_plugin(WebConsole::Tests::PRINT_PLUGIN_FILE)
  end
  
  def teardown
    @window_one.close
    WebConsole::Tests::Helper::confirm_dialog
  
    @window_two.close
    WebConsole::Tests::Helper::confirm_dialog
  end

  # LASTCODEJAVASCRIPT_FILE = File.join(TEST_DATA_DIRECTORY, "lastcode.js")
  def test_two_windows
    # test_text_one = "The first test string"
    # test_text_two = "The second test string"

    # Window Manager One
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    window_id_one = WebConsole::window_id_for_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    @window_one = WebConsole::Window.new(window_id_one)
    # WebConsole::plugin_read_from_standard_input(PRINTPLUGIN_NAME, test_text_one + "\n")
    # sleep PAUSE_TIME # Give read from standard input time to run

    # Window Manager Two
    WebConsole::run_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    window_id_two = WebConsole::window_id_for_plugin(WebConsole::Tests::PRINT_PLUGIN_NAME)
    @window_two = WebConsole::Window.new(window_id_two)
    # WebConsole::plugin_read_from_standard_input(PRINTPLUGIN_NAME, test_text_two + "\n")
    # sleep PAUSE_TIME # Give read from standard input time to run

    # TODO This test doesn't really work because plugin_read_from_standard_input can't target a unique window, finish this test when that functionality exists. For now the only thing valid to test is that the window ids are different.

    assert_not_equal(window_id_one, window_id_two, "Window managers one and two should have different window ids.")

    # TODO Switch the window order of window manager's one and two

    # javascript = File.read(LASTCODEJAVASCRIPT_FILE)
    # 
    # # Window Manager One
    # result_one = @window_one.do_javascript(javascript)
    # result_one.strip!
    # 
    # # Window Manager Two
    # result_two = @window_two.do_javascript(javascript)
    # result_two.strip!
    # 
    # assert_equal(test_text_one, result_one, "The first test text should equal the first result.")
    # assert_equal(test_text_two, result_two, "The second test text should equal the second result.")
  end
end
