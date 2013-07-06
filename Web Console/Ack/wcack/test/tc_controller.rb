#!/usr/bin/env ruby

require "test/unit"
require 'webconsole'
require 
CONSTANTS_FILE = File.join(File.dirname(__FILE__), 'test_constants')
require CONSTANTS_FILE
require PARSER_FILE


class TestController < Test::Unit::TestCase
  SEARCH_DIRECTORY = File.join(File.dirname(__FILE__), '../../../../')
  SEARCH_TERM = "test"
  def test_matches_count
    match_count = `ack --no-filename --count #{SEARCH_TERM} #{SEARCH_DIRECTORY}`
    puts match_count

    # puts SEARCH_DIRECTORY
  end
end