TEST_PLUGIN_PATH = File.expand_path(File.join(File.dirname(__FILE__), "../../../.."))
TEST_PLUGIN_NAME = "Node"

TEST_CODE = %Q[var add;
add = function(x, y) {
  return x + y;
};
add(1, 2);]
TEST_CODE_RESULT = 3