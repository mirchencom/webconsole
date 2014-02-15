TEST_LIB_DIRECTORY = File.dirname(__FILE__)
TEST_TEMPLATE_FILE = File.join(TEST_LIB_DIRECTORY, "view.html.erb")
CONSTANTS_FILE = File.join(TEST_LIB_DIRECTORY, "..", "..", "lib", "webconsole", "constants")

# Plugins
TEST_DATA_DIRECTORY = File.join(TEST_LIB_DIRECTORY, "..", "data")
DATA_PLUGIN_FILE = File.join(TEST_DATA_DIRECTORY, "Data.wcplugin")
DATA_PLUGIN_NAME = "Data"
DATA_PLUGIN_PATH_KEY = "Path"
DATA_PLUGIN_ARGUMENTS_KEY = "Arguments"