#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative '../bundle/bundler/setup'
require 'webconsole'

require_relative "lib/git_test_helper"
require_relative "lib/test_data"

require_relative "../lib/git_manager"

class TestGitManager < Test::Unit::TestCase

  def test_git_manager
    git_helper = WebConsole::Git::Tests::GitHelper.new
    git_helper.add_file(TEST_FILE_ONE, TEST_FILE_ONE_CONTENT)
    git_helper.add_file(TEST_FILE_TWO, TEST_FILE_TWO_CONTENT)
    git_helper.git_init

    git_manager = WebConsole::Git::GitManager.new(git_helper.path.to_s)

    git_manager.git_status
    
  
    git_helper.clean_up
  end

  # def test_git_manager2
  #   git_manager = WcGit::GitManager.new("/tmp/git_test_helper-uU4Ish")
  # 
  #   git_manager.git_status
  # end

end