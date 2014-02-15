#!/usr/bin/env ruby

require 'Shellwords'

# Temporary hack because for some reason these scripts won't run within Textmate

SCRIPT_DIRECTORY = File.dirname(__FILE__)
TEST_ACK_OUTPUT_FILE = File.join(SCRIPT_DIRECTORY, "test_ack_output.rb")
TEST_DATA_JSON_FILE = File.join(SCRIPT_DIRECTORY, "test_data_json.rb")

OUTPUT_DIRECTORY = File.join(SCRIPT_DIRECTORY, "output")
TEST_ACK_OUTPUT_OUTPUT_FILE = File.join(OUTPUT_DIRECTORY, "test_ack_output")
TEST_DATA_JSON_OUTPUT_FILE = File.join(OUTPUT_DIRECTORY, "test_data_json.json")

test_ack_output_command = "#{Shellwords.escape(TEST_ACK_OUTPUT_FILE)} > #{Shellwords.escape(TEST_ACK_OUTPUT_OUTPUT_FILE)}"
test_data_json_command = "#{Shellwords.escape(TEST_DATA_JSON_FILE)} > #{Shellwords.escape(TEST_DATA_JSON_OUTPUT_FILE)}"

# puts test_ack_output_command
# puts test_data_json_command
# exit 0

`#{test_ack_output_command}`
`#{test_data_json_command}`