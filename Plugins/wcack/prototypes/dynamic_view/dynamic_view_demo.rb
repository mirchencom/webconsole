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

# JavaScript to run
text = "- [Best way to generate javascript code in ruby (RoR) - Stack Overflow](http://stackoverflow.com/questions/3362905/best-way-to-generate-javascript-code-in-ruby-ror)"
javascript = %Q[
var matches = [
	{
		index: 24,
		length: 10
	},
	{
		index: 136,
		length: 10
	}
];
addFile('#{file.file_path}');
addLine(10, '#{text}', matches);
addLine(20, '#{text}', matches);
addFile('#{file.file_path}');
addLine(30, '#{text}', matches);
]

# Run the JavaScript
root_url = File.expand_path(File.dirname(__FILE__))
javascript = URI::encode(javascript)
html = URI::encode(template_erb.result)
STDOUT.puts `domrunner --eh #{Shellwords.escape(html)} --ej #{Shellwords.escape(javascript)} -u #{Shellwords.escape(root_url)}`