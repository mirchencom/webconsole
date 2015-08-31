#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "../lib/webconsole"

class TestLogger < Test::Unit::TestCase

  def test_constants
    message_prefix = WebConsole::Logger::MESSAGE_PREFIX
    assert_not_nil(message_prefix, "The message prefix should not be nil.")
    error_prefix = WebConsole::Logger::ERROR_PREFIX
    assert_not_nil(message_prefix, "The error prefix should not be nil.")
  end

end
