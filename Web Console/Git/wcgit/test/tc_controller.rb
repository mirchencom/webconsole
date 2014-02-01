#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE

require TEST_GIT_HELPER_FILE
require TEST_DATA_FILE

require TEST_WINDOW_MANAGER_HELPER

require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

class TestController < Test::Unit::TestCase

  def test_class
    git_helper = WcGit::Tests::GitHelper.new
  
    git_helper.add_file(TEST_FILE_ONE, TEST_FILE_ONE_CONTENT)
    git_helper.add_file(TEST_FILE_TWO, TEST_FILE_TWO_CONTENT)
  
    git_helper.clean_up
  end

  def test_set_branch
    window_manager = WcGit::WindowManager.new
    controller = WcGit::Controller.new(window_manager)

    branch_name = "master"
    controller.branch = branch_name
    assert(branch_name = controller.branch, "The controller's branch should equal the branch name.")

    branch_name = "development"
    controller.branch = branch_name
    window_manager_test_helper = WcGit::Tests::WindowManagerHelper.new(window_manager)
    branch_element_count = window_manager_test_helper.element_count_for_selector("[id=branch]").to_i # Alternative ID selector syntax will select multiple elements with the same ID.
    assert(branch_element_count == 1, "There should be one branch element.")
    assert(branch_name = controller.branch, "The controller's branch should equal the branch name.")

    # window_manager.close
  end

end