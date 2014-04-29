#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative "../wcdependencies"
require_relative "../lib/controller"
require_relative "lib/test_javascript_helper"

module WcDependencies
  class Checker

    def close
      if @controller
        @controller.view.close
      end
    end

    def view
      return @controller.view
    end

    def controller_exists?
      if @controller
        return true
      else
        return false
      end
    end

  end
end

class TestController < Test::Unit::TestCase
  def setup    
    @checker = WcDependencies::Checker.new
  end
  
  def teardown
    @checker.close
  end

  def test_missing_dependency
    dependency = WcDependencies::Dependency.new("asdf", :shell_command)

    passed = @checker.check(dependency)

    assert(!passed, "The check should have failed.")

    test_result_name = WcDependencies::Tests::JavaScriptHelper::last_name(@checker.view)
    assert(!test_result_name.empty?, "The test result name should not be empty.")
    assert_equal(test_result_name, dependency.name, "The test result name should equal the test name.")    

    test_type_string = WcDependencies::Controller.send(:string_for_type, dependency.type)
    test_result_type = WcDependencies::Tests::JavaScriptHelper::last_type(@checker.view)
    assert(!test_result_type.empty?, "The test result type should not be empty.")
    assert_equal(test_result_type, test_type_string, "The test result type should equal the test type string.")
  end

  def test_present_dependency
    dependency = WcDependencies::Dependency.new("grep", :shell_command)

    passed = @checker.check(dependency)

    assert(passed, "The check should have passed")
    assert(!@checker.controller_exists?, "The checker's controller should not exit.")
  end

  def test_mixed_dependencies
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    passing_dependency = WcDependencies::Dependency.new("grep", :shell_command)
    failing_dependency = WcDependencies::Dependency.new("asdf", :shell_command)
    failing_dependency_with_installation = WcDependencies::Dependency.new("asdf", :shell_command, :installation_instructions => test_installation)

    test_count_type = 2
    test_count_name = test_count_type
    test_count_installation = 1

    passed = @checker.check(passing_dependency)
    assert(passed, "The check should have passed.")

    passed = @checker.check(failing_dependency)
    assert(!passed, "The check should have failed.")

    passed = @checker.check(failing_dependency_with_installation)
    assert(!passed, "The check should have failed.")

    assert(@checker.controller_exists?, "The checker's controller should exist.")
    
    test_result_count_name = WcDependencies::Tests::JavaScriptHelper::count_name(@checker.view)
    test_result_count_type = WcDependencies::Tests::JavaScriptHelper::count_type(@checker.view)
    test_result_count_installation = WcDependencies::Tests::JavaScriptHelper::count_installation(@checker.view)

    assert_equal(test_result_count_name, test_count_name, "The test result name count should equal the test name count.")
    assert_equal(test_result_count_type, test_count_type, "The test result type count should equal the test type count.")
    assert_equal(test_result_count_installation, test_count_installation, "The test result installation count should equal the test installation count.")
  end

  def test_batch_mixed_dependencies
    test_installation = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew install asdf</code>'    
    passing_dependency = WcDependencies::Dependency.new("grep", :shell_command)
    failing_dependency = WcDependencies::Dependency.new("asdf", :shell_command)
    failing_dependency_with_installation = WcDependencies::Dependency.new("asdf", :shell_command, :installation_instructions => test_installation)

    dependencies = [passing_dependency, failing_dependency, failing_dependency_with_installation]

    test_count_type = 2
    test_count_name = test_count_type
    test_count_installation = 1

    passed = @checker.check_dependencies(dependencies)
    assert(!passed, "The check should have failed.")

    assert(@checker.controller_exists?, "The checker's controller should exist.")
    
    test_result_count_name = WcDependencies::Tests::JavaScriptHelper::count_name(@checker.view)
    test_result_count_type = WcDependencies::Tests::JavaScriptHelper::count_type(@checker.view)
    test_result_count_installation = WcDependencies::Tests::JavaScriptHelper::count_installation(@checker.view)

    assert_equal(test_result_count_name, test_count_name, "The test result name count should equal the test name count.")
    assert_equal(test_result_count_type, test_count_type, "The test result type count should equal the test type count.")
    assert_equal(test_result_count_installation, test_count_installation, "The test result installation count should equal the test installation count.")
  end

end