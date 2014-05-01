#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative "lib/test_constants"
require WEBCONSOLE_FILE

require_relative "lib/test_javascript_helper"

require_relative "../lib/controller"
require_relative "../lib/model"

class TestController < Test::Unit::TestCase
  def setup
    @controller = WcDependencies::Controller.new
  end
  
  def teardown
    @controller.view.close
  end

  def test_missing_dependency
    dependency = WcDependencies::Dependency.new("asdf", :shell_command)

    @controller.missing_dependency(dependency)

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@controller.view)
    assert(!test_result_name.empty?, "The test result name should not be empty.")
    assert_equal(test_result_name, dependency.name, "The test result name should equal the dependency's name.")    

    test_type_string = @controller.class.send(:string_for_type, dependency.type)
    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@controller.view)
    assert(!test_result_type.empty?, "The test result type should not be empty.")
    assert_equal(test_result_type, test_type_string, "The test result type should equal the test type string.")
  end

  def test_missing_with_installation_instructions
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    dependency = WcDependencies::Dependency.new("asdf", :shell_command, :installation_instructions => test_installation)

    @controller.missing_dependency(dependency)

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@controller.view)
    assert(!test_result_name.empty?, "The test result name should not be empty.")
    assert_equal(test_result_name, dependency.name, "The test result name should equal the dependency's name.")

    test_type_string = @controller.class.send(:string_for_type, dependency.type)
    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@controller.view)
    assert(!test_result_type.empty?, "The test result type should not be empty.")
    assert_equal(test_result_type, test_type_string, "The test result type should equal the test type string.")

    test_result_installation = WcDependencies::Tests::JavaScriptHelper::last_installation(@controller.view)
    assert(test_result_installation.end_with? test_installation, "The test result installation should end with the installation.")
  end

  def test_mutiple_missing_dependencies
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    dependency_with_installation = WcDependencies::Dependency.new("asdf", :shell_command, :installation_instructions => test_installation)
    dependency = WcDependencies::Dependency.new("asdf", :shell_command)
    
    test_count_type = 4
    test_count_name = test_count_type
    test_count_installation = 3
    @controller.missing_dependency(dependency_with_installation)
    @controller.missing_dependency(dependency)
    @controller.missing_dependency(dependency_with_installation)
    @controller.missing_dependency(dependency_with_installation)
    
    test_result_count_name = WcDependencies::Tests::JavaScriptHelper::count_name(@controller.view)
    test_result_count_type = WcDependencies::Tests::JavaScriptHelper::count_type(@controller.view)
    test_result_count_installation = WcDependencies::Tests::JavaScriptHelper::count_installation(@controller.view)

    assert_equal(test_result_count_name, test_count_name, "The test result name count should equal the test name count.")
    assert_equal(test_result_count_type, test_count_type, "The test result type count should equal the test type count.")
    assert_equal(test_result_count_installation, test_count_installation, "The test result installation count should equal the test installation count.")
  end
end