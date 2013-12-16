#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), 'lib', 'test_constants')
require TEST_CONSTANTS_FILE
require CONTROLLER_FILE
require WINDOW_MANAGER_FILE


# Test cases for some situations where `textWithMatchesProcessed` was failing.
# To debug these situations: Run a test case and then use Web Console's Web Inspector to log console messages from the `textWithMatchesProcessed` JavaScript.

class TestJavaScript < Test::Unit::TestCase

  def setup
    @window_manager = WcSearch::WindowManager.new
    controller = WcSearch::Controller.new(@window_manager)
  end
  
  def teardown
    @window_manager.close
  end

  def test_javascript_escape
    test_result = "&lt;string&gt;<strong>eiusmod</strong>&#x2F;<strong>eiusmod</strong>.rb&lt;&#x2F;string&gt;"
    javascript = %Q[
var matches = [ 
  {
    index: 8,
    length: 7
  }, 
  {
    index: 16,
    length: 7
  }  
];
var text = '<string>eiusmod/eiusmod.rb</string>';
textWithMatchesProcessed(text, 0, matches);]
    result = @window_manager.do_javascript(javascript)
    result.chomp!    
    assert(result == test_result, "The result should match the test result.")
  end



  def test_javascript_quote
    test_result = 'WCSEARCH_FILE = File.join(File.dirname(__FILE__), &quot;..&quot;, &#39;<strong>eiusmod</strong>.rb&#39;)'
    javascript = %Q[
var matches = [ 
  {
    index: 57,
    length: 7
  }
];
var text = 'WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", \\\'eiusmod.rb\\\')';
textWithMatchesProcessed(text, 0, matches);]
    result = @window_manager.do_javascript(javascript)
    result.chomp!
    assert(result == test_result, "The result should match the test result.")
  end



  def test_javascript_first
    test_result = '    <strong>eiusmod</strong>_tests_file = File.join(File.dirname(__FILE__), &quot;tc_<strong>eiusmod</strong>.rb&quot;)'
    javascript = %Q[
var matches = [ 
  {
    index: 4,
    length: 7
  }, 
  {
    index: 63,
    length: 7
  }  
];
var text = '    eiusmod_tests_file = File.join(File.dirname(__FILE__), "tc_eiusmod.rb")';
textWithMatchesProcessed(text, 0, matches);]
    result = @window_manager.do_javascript(javascript)
    result.chomp!
    assert(result == test_result, "The result should match the test result.")
  end

end