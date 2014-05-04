TEST_PLUGIN_PATH = File.expand_path(File.join(File.dirname(__FILE__), "../../../.."))
TEST_PLUGIN_NAME = "Coffee"

TEST_CODE = %Q[add = (x, y)->
      x + y
add(1, 2)]
TEST_CODE_RESULT = "3"