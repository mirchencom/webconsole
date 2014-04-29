#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "lib/test_javascript_constants"
require_relative "../lib/webconsole"
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE


class TestViewBaseURL < Test::Unit::TestCase
  def test_base_url
    view = WebConsole::View.new
    view.base_url = TEST_BASE_URL
    view.load_erb_from_path(TEST_TEMPLATE_FILE)
    result = view.do_javascript_function(TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_NAME)
    assert_equal(result, TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_RESULT, "The result should equal the expected result.")
    view.close
  end
end

class TestViewJavaScript < Test::Unit::TestCase

  def setup
    @view = WebConsole::View.new
    @view.base_url_path = TEST_BASE_URL_PATH
    @view.load_erb_from_path(TEST_TEMPLATE_FILE)
  end

  def teardown
    @view.close    
  end

  def test_resources

    # Testing jquery assures that `zepto.js` has been loaded correctly
    javascript = File.read(WebConsole::Tests::TEXTJQUERY_JAVASCRIPT_FILE)
    result = @view.do_javascript(javascript)

    test_javascript = File.read(WebConsole::Tests::TEXT_JAVASCRIPT_FILE)
    expected = @view.do_javascript(test_javascript)

    assert_equal(expected, result, "The result should equal expected result.")

  end

  def test_javascript_function_without_arguments
    result = @view.do_javascript_function(TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_NAME)
    assert_equal(result, TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_RESULT, "The result should equal the expected result.")
  end

  def test_javascript_function_with_arguments
    result = @view.do_javascript_function(TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_NAME, TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_ARGUMENTS)
    assert_equal(result, TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_RESULT, "The result should equal the expected result.")
  end

end

class TestViewEnvironmentVariables < Test::Unit::TestCase

  def test_shared_resource_url_from_environment_variable  

    shared_resource_url = WebConsole::shared_resources_url.to_s
    ENV[WebConsole::SHARED_RESOURCES_URL_KEY] = shared_resource_url
    view = WebConsole::View.new
    view.load_erb_from_path(TEST_TEMPLATE_FILE)
    WebConsole::Tests::Helper::quit
  
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Give time for application to quit

    result_shared_resource_url = view.send(:shared_resources_url)  
    
    assert_equal(result_shared_resource_url, shared_resource_url, "The result shared resource URL should equal the shared resource URL.")
    assert(!WebConsole::Tests::Helper::is_running, "Web Console should not be running.")
  end

end
