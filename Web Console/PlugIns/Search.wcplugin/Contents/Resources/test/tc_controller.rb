#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_data_helper"
require_relative "lib/test_data_parser"
require_relative "lib/test_javascript_helper"
require_relative "lib/test_parser_additions"
require_relative "lib/test_data_tester"

require_relative "../lib/dependencies"
require_relative "../lib/parser"
require_relative "../lib/controller"


class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    passed = WcSearch.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end


class TestController < Test::Unit::TestCase

  def test_controller
    test_search_output = WcSearch::Tests::TestData::test_search_output
    test_data_directory = WcSearch::Tests::TestData::test_data_directory

    window_manager = WcSearch::WindowManager.new
    controller = WcSearch::Controller.new(window_manager)
    parser = WcSearch::Parser.new(controller, test_data_directory)
    parser.parse(test_search_output)

    files_json = WcSearch::Tests::JavaScriptHelper::files_hash_for_window_manager(window_manager)
    files_hash = WcSearch::Tests::Parser::parse(files_json)

    test_data_json = WcSearch::Tests::TestData::test_data_json
    test_files_hash = WcSearch::Tests::Parser::parse(test_data_json)

    file_hashes_match = WcSearch::Tests::TestDataTester::test_file_hashes(files_hash, test_files_hash)
    assert(file_hashes_match, "The file hashes should match.")

    window_manager.close
  end

end