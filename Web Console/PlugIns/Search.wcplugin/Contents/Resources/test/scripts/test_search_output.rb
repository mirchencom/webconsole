#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require 'Shellwords'

require_relative "../lib/test_script_constants"
require_relative "../../lib/constants"

command = "#{SEARCH_COMMAND} \"#{SEARCH_TERM}\" #{Shellwords.escape(TEST_DATA_DIRECTORY)}"
result = `#{command}`
puts result