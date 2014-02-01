#!/usr/bin/env ruby

require "test/unit"

TEST_CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "test_constants")
require TEST_CONSTANTS_FILE

require GIT_TEST_HELPER_FILE

require TEST_DATA_FILE

require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

class TestController < Test::Unit::TestCase

  # def test_class
  #   git_test_helper = WcGit::GitTestHelper.new
  # 
  #   git_test_helper.add_file(TEST_FILE_ONE, TEST_FILE_ONE_CONTENT)
  #   git_test_helper.add_file(TEST_FILE_TWO, TEST_FILE_TWO_CONTENT)
  # 
  #   git_test_helper.clean_up
  # end

  def test_set_branch
    window_manager = WcGit::WindowManager.new
    controller = WcGit::Controller.new(window_manager)

    branch_name = "master"
    controller.branch = branch_name

    assert(branch_name = controller.branch, "The controller's branch should equal the branch name.")

    window_manager.close
  end

end