#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_data_helper"
require_relative "lib/test_data_parser"
require_relative "lib/test_parser_additions"
require_relative "lib/test_data_tester"

require_relative "../lib/dependencies"
require_relative "../lib/parser"

class TestDependencies < Test::Unit::TestCase
  def test_dependencies
    ENV[WebConsole::PLUGIN_NAME_KEY] = "Search"
    passed = WcSearch.check_dependencies
    assert(passed, "The dependencies check should have passed.")
  end
end

class TestParser < Test::Unit::TestCase

  def test_parser
    test_search_output = WcSearch::Tests::TestData::test_search_output
    test_data_directory = WcSearch::Tests::TestData::test_data_directory
    
    parser = WcSearch::Parser.new(nil, test_data_directory)
    parser.parse(test_search_output)
    files_hash = parser.files_hash

    test_data_json = WcSearch::Tests::TestData::test_data_json
    test_files_hash = WcSearch::Tests::Parser::parse(test_data_json)

    file_hashes_match = WcSearch::Tests::TestDataTester::test_file_hashes(files_hash, test_files_hash)
    assert(file_hashes_match, "The file hashes should match.")
  end
end