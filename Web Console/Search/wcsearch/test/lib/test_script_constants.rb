require File.join(File.dirname(__FILE__), "../..", "lib", "constants")
SEARCH_TERM = "ei.*?od"
TEST_DATA_DIRECTORY = File.join(File.dirname(__FILE__), "..", "data")
TEST_DATA_SEARCH_COMMAND = "ack -o --with-filename --noheading --nocolor"