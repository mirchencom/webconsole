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
file_erb = ERB.new(File.new(FILE_PARTIAL).read, nil, '-')

file_html = file_erb.result
# javascript = %Q[
# addFileHTML('#{FILE_PATH}');
# ]
javascript = %Q[
addFileHTML('#{file_html}');
]



root_url = File.dirname(__FILE__)
javascript = URI::encode(javascript)
html = URI::encode(template_erb.result)
STDOUT.puts `domrunner -e --eh #{Shellwords.escape(html)} --ej #{Shellwords.escape(javascript)} -u #{Shellwords.escape(root_url)}`