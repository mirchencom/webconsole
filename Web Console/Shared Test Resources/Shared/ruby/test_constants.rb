module WebConsole
  module Tests
    TEST_RUBY_DIRECTORY = File.dirname(__FILE__)
    TEST_HELPER_FILE = File.join(TEST_RUBY_DIRECTORY, "test_helper")
    TEST_PAUSE_TIME = 0.5

    TEST_PLUGIN_DIRECTORY = File.join(TEST_RUBY_DIRECTORY, "..", "plugin")
    HELLOWORLD_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY, "HelloWorld.bundle")
    HELLOWORLD_PLUGIN_NAME = "HelloWorld"
    PRINT_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY, "Print.bundle")
    PRINT_PLUGIN_NAME = "Print"
  end
end