TEST_LIB_DIRECTORY = File.dirname(__FILE__)

# Template
TEST_TEMPLATE_FILE = File.join(TEST_LIB_DIRECTORY, "../view/view.html.erb")

# Base URL
TEST_BASE_URL_PATH = File.join(TEST_LIB_DIRECTORY, "..")
TEST_BASE_URL = "file://" + TEST_BASE_URL_PATH

# Data Plugin
TEST_DATA_DIRECTORY = File.join(TEST_LIB_DIRECTORY, "..", "data")
DATA_PLUGIN_FILE = File.join(TEST_DATA_DIRECTORY, "Data.wcplugin")
DATA_PLUGIN_NAME = "Data"
DATA_PLUGIN_PATH_KEY = "Path"
DATA_PLUGIN_ARGUMENTS_KEY = "Arguments"

# Test Data
TEST_TITLE = "Test"
TEST_TITLE_JAVASCRIPT = "document.title"