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

class TestViewTitle < Test::Unit::TestCase

  def test_no_title
    view = WebConsole::View.new
    view.base_url = TEST_BASE_URL
    view.load_erb_from_path(TEST_TEMPLATE_FILE)
    
    assert_nil(view.title, "The views title should be nil.")
    
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    title_result.chomp!
    assert(title_result.empty?, "The title result should be empty.")
    view.close
  end

  def test_set_title
    view = WebConsole::View.new
    view.base_url = TEST_BASE_URL
    view.title = TEST_TITLE
    view.load_erb_from_path(TEST_TEMPLATE_FILE)
    
    assert_equal(view.title, TEST_TITLE, "The view's title should equal the test title.")
  
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    title_result.chomp!
    assert_equal(title_result, TEST_TITLE, "The title result should equal the test title.")
    view.close
  end
  

  def test_title_environment_variable
    view = WebConsole::View.new
    view.base_url = TEST_BASE_URL
    ENV[WebConsole::PLUGIN_NAME_KEY] = TEST_TITLE
    view.load_erb_from_path(TEST_TEMPLATE_FILE)
    
    assert_equal(view.title, TEST_TITLE, "The view's title should equal the test title.")
  
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    title_result.chomp!
    assert_equal(title_result, TEST_TITLE, "The title result should equal the test title.")
    view.close
  end

end