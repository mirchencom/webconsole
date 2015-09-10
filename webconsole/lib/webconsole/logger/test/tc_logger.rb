#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require WEBCONSOLE_FILE
require WebConsole::shared_test_resource("ruby/test_constants")
require WebConsole::Tests::TEST_HELPER_FILE

require_relative "lib/test_view_helper"
require_relative "../../logger"


class TestConstants < Test::Unit::TestCase

  def test_constants
    message_prefix = WebConsole::Logger::MESSAGE_PREFIX
    assert_not_nil(message_prefix, "The message prefix should not be nil.")
    error_prefix = WebConsole::Logger::ERROR_PREFIX
    assert_not_nil(message_prefix, "The error prefix should not be nil.")
  end

end


class TestUnintializedLogger < Test::Unit::TestCase

  def teardown
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

  def test_uninitialized_logger
    logger = WebConsole::Logger.new

    # Test Message
    message = "Testing log message"
    logger.info(message)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed

    # Make sure the log messages before accessing the logger's `view_id` and `window_id` because those run the logger.
    # This test should test logging a message and running the logger itself simultaneously.
    # This is why the `TestViewHelper` is intialized after logging the message.
    test_view_helper = TestViewHelper.new(logger.window_id, logger.view_id)

    test_message = test_view_helper.last_log_message
    assert_equal(message, test_message, "The messages should match")
    test_class = test_view_helper.last_log_class
    assert_equal("message", test_class, "The classes should match")

  end

end


class TestLogger < Test::Unit::TestCase

  def setup
    @logger = WebConsole::Logger.new
    @logger.show
    @test_view_helper = TestViewHelper.new(@logger.window_id, @logger.view_id)
  end

  def teardown
    WebConsole::Tests::Helper::quit
    WebConsole::Tests::Helper::confirm_dialog
    assert(!WebConsole::Tests::Helper::is_running, "The application should not be running.")
  end

  def test_logger
    # Test Message
    message = "Testing log message"
    @logger.info(message)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_view_helper.last_log_class
    assert_equal("message", test_class, "The classes should match")
    test_count = @test_view_helper.number_of_log_messages
    assert_equal(1, test_count, "The number of log messages should match")

    # Test Error
    message = "Testing log error"
    @logger.error(message)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message, "The messages should match")
    test_class = @test_view_helper.last_log_class
    assert_equal("error", test_class, "The classes should match")
    test_count = @test_view_helper.number_of_log_messages
    assert_equal(2, test_count, "The number of log messages should match")
  end

  def test_long_input
    # Test Message
    message = %q(
Line 1
Line 2
Line 3
)
    @logger.info(message)
    sleep WebConsole::Tests::TEST_PAUSE_TIME # Pause for output to be processed
    test_count = @test_view_helper.number_of_log_messages
    assert_equal(test_count, 3, "The number of log messages should match")    

    (1..3).each { |i|
      result = @test_view_helper.log_message_at_index(i - 1)
      test_result = "Line #{i}"
      assert_equal(result, test_result, "The number of log messages should match")    
    }

    # @logger.info(line_one)

    # TODO: Assert there should be three `<p>` tags

    # test_message = @test_view_helper.last_log_message
    # assert_equal(message, test_message, "The messages should match")
    # test_class = @test_view_helper.last_log_class
    # assert_equal("message", test_class, "The classes should match")

    # Get the body text
  end

  # TODO: Test multi-line input

  # TODO: Test line endings the logger should handle this

  # TODO: Test white space at beginning and end of lines

end
