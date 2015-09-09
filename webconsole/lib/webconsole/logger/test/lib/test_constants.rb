require_relative "../../../extension_constants"

TEST_CLASS_JAVASCRIPT = "document.body.lastChild.classList[0]"
TEST_MESSAGE_JAVASCRIPT = "document.body.lastChild.innerText"
TEST_MESSAGE_COUNT_JAVASCRIPT = "document.body.children.length"

TEST_JAVASCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "..", "js")
TEST_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY, "test_view_helper.js")
