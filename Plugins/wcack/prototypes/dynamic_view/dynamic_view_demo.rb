#!/usr/bin/env ruby

require 'erb'
require 'Shellwords'
require 'open-uri'

MODEL_FILE = File.join(File.dirname(__FILE__), 'lib', 'model')
require MODEL_FILE

# Templates
TEMPLATE_DIRECTORY = File.join(File.dirname(__FILE__), 'views')
FILE_PARTIAL = File.join(TEMPLATE_DIRECTORY, "_file.html.erb")
VIEW_TEMPLATE = File.join(TEMPLATE_DIRECTORY, "view.html.erb")

template_erb = ERB.new(File.new(VIEW_TEMPLATE).read, nil, '-')

# Sample Data
FILE_PATH = "/Users/robenkleene/Dropbox/Text/Inbox/Web Console/AppleScript Support.md"
file = WcAck::Match::File.new(FILE_PATH)


lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
javascript = %Q[
addFile('#{file.file_path}');
addLine(10, "test");
addLine(20, "test2");
addFile('#{file.file_path}');
addLine(30, "test3");
addLineWithMatchesTest(20, '#{lorem}')
]

root_url = File.dirname(__FILE__)
javascript = URI::encode(javascript)
html = URI::encode(template_erb.result)
STDOUT.puts `domrunner -e --eh #{Shellwords.escape(html)} --ej #{Shellwords.escape(javascript)} -u #{Shellwords.escape(root_url)}`