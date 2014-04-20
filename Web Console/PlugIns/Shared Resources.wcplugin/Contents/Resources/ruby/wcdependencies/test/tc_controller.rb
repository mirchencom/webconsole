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
    test_name = "asdf"
    test_type = :shell_command
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    
    @controller.check(test_name, test_type, :installation_instructions => test_installation)

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@window_manager)
    assert(!test_result_name.empty?, "The test result name should not be empty.")
    assert_equal(test_result_name, test_name, "The test result name should equal the test name.")    

    test_type_string = @controller.class.send(:string_for_type, test_type)
    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@window_manager)
    assert(!test_result_type.empty?, "The test result type should not be empty.")
    assert_equal(test_result_type, test_type_string, "The test result type should equal the test type string.")

    test_result_installation = WcDependencies::Tests::JavaScriptHelper::last_installation(@window_manager)
    assert(test_result_installation.end_with? test_installation, "The test result installation should end with the installation.")
  end

  def test_two_missing_dependencies
    test_name = "asdf"
    test_type = :shell_command
    test_installation_instructions = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    
    test_count_type = 4
    test_count_name = test_count_type
    test_count_installation = 3
    @controller.check(test_name, test_type, :installation_instructions => test_installation_instructions)
    @controller.check(test_name, test_type)
    @controller.check(test_name, test_type, :installation_instructions => test_installation_instructions)
    @controller.check(test_name, test_type, :installation_instructions => test_installation_instructions)
    
    test_result_count_name = WcDependencies::Tests::JavaScriptHelper::count_name(@window_manager)
    test_result_count_type = WcDependencies::Tests::JavaScriptHelper::count_type(@window_manager)
    test_result_count_installation = WcDependencies::Tests::JavaScriptHelper::count_installation(@window_manager)

    assert_equal(test_result_count_name, test_count_name, "The test result name count should equal the test name count.")
    assert_equal(test_result_count_type, test_count_type, "The test result type count should equal the test type count.")
    assert_equal(test_result_count_installation, test_count_installation, "The test result installation count should equal the test installation count.")
  end

  def test_present_with_installation_instructions
    test_name = "grep"
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    
    @controller.check(test_name, :shell_command, :installation_instructions => test_installation)

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@window_manager)
    assert(test_result_name.empty?, "The test result name should be empty.")

    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@window_manager)
    assert(test_result_type.empty?, "The test result type should be empty.")

    test_result_installation = WcDependencies::Tests::JavaScriptHelper::last_installation(@window_manager)
    assert(test_result_installation.empty?, "The test result installation should be empty.")
  end

end