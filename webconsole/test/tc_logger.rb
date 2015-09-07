#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "../lib/webconsole"
require_relative "lib/test_view_helper"
require_relative "lib/test_javascript_constants"

require 'webconsole'
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE


class TestConstants < Test::Unit::TestCase

  def test_constants
    message_prefix = WebConsole::Logger::MESSAGE_PREFIX
    assert_not_nil(message_prefix, "The message prefix should not be nil.")
    error_prefix = WebConsole::Logger::ERROR_PREFIX
    assert_not_nil(message_prefix, "The error prefix should not be nil.")
  end

end


class TestUnintializedLogger < Test::Unit::TestCase

  def test_logger
    logger = WebConsole::Logger.new
    

    # Test Message
    message = "Testing log message\n"
    logger.info(message)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    

    # Make sure the log messages before accessing the logger's `view_id` and `window_id` because those run the logger.
    # This test should test logging a message and running the logger itself simultaneously.
    # This is why the `LoggerViewHelper` is intialized after logging the message.
    logger_view_helper = LoggerViewHelper.new(logger.window_id, logger.view_id)

    test_message = logger_view_helper.last_log_message
    assert_equal(message, test_message, "The messages should match")
    test_class = logger_view_helper.last_log_class
    assert_equal("message", test_class, "The classes should match")
    
  end
  

end


class TestLogger < Test::Unit::TestCase

  def test_logger
  end

  # TODO Test multi-line input

end

# Helper

class LoggerViewHelper < TestViewHelper
  
  def last_log_message
    do_javascript(TEST_MESSAGE_JAVASCRIPT)
  end
  
  def last_log_class
    do_javascript(TEST_CLASS_JAVASCRIPT)
  end
end