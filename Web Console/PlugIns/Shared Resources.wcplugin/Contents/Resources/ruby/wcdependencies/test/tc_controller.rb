#!/usr/bin/env ruby

require "test/unit"
require_relative "../lib/controller"
require_relative "../lib/window_manager"
require_relative "lib/test_javascript_helper"

class TestController < Test::Unit::TestCase
  def setup
    @window_manager = WcDependencies::WindowManager.new
    @controller = WcDependencies::Controller.new(@window_manager)
  end
  
  def teardown
    @window_manager.close
  end

  def test_missing_dependency
    test_name = "asdf"
    test_type = :shell_command

    @controller.check(test_name, test_type)

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@window_manager)
    assert(!test_result_name.empty?, "The test result name should not be empty.")
    assert_equal(test_result_name, test_name, "The test result name should equal the test name.")    


    test_type_string = @controller.class.send(:string_for_type, test_type)
    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@window_manager)
    assert(!test_result_type.empty?, "The test result type should not be empty.")
    assert_equal(test_result_type, test_type_string, "The test result type should equal the test type string.")
  end

  def test_present_dependency
    test_name = "grep"

    @controller.check(test_name, :shell_command)

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@window_manager)
    assert(test_result_name.empty?, "The test result name should be empty.")

    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@window_manager)
    assert(test_result_type.empty?, "The test result type should be empty.")
  end

  def test_missing_with_installation_instructions
  end

  def test_present_with_installation_instructions
  end

end

# TODO Sends to the delegate "Dependency shell command <code>ack</code> not found."
# TODO To install <code>ack</code>: Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install ack</code>.
