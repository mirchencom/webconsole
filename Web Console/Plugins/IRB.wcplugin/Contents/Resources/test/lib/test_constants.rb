TEST_PLUGIN_PATH = File.expand_path(File.join(File.dirname(__FILE__), "../../../.."))
TEST_PLUGIN_NAME = "IRB"

TEST_CODE = %Q[def add_numbers(num1, num2)
  return num1 + num2
end
add_numbers(1, 2)]
TEST_CODE_RESULT = 3