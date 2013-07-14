#!/usr/bin/env ruby

require 'erb'
require 'Shellwords'
require 'open-uri'

BASE_DIRECTORY = File.join(File.dirname(__FILE__), '..')
VIEW_DIRECTORY = File.join(BASE_DIRECTORY, 'view')
VIEW_TEMPLATE = File.join(VIEW_DIRECTORY, "view.html.erb")

view_erb = ERB.new(File.new(VIEW_TEMPLATE).read, nil, '-')

output = "=> 4"
# Escape output
# CGI.escapeHTML(line.text)
# javascript = "addFile('#{file.file_path.gsub("'", "\\\\'")}');"

javascript = %Q[
addOutput('#{output}');
addOutput('#{output}');
]

root_url = File.expand_path(BASE_DIRECTORY)
javascript = URI::encode(javascript)
html = URI::encode(view_erb.result)
STDOUT.puts `domrunner --eh #{Shellwords.escape(html)} --ej #{Shellwords.escape(javascript)} -u #{Shellwords.escape(root_url)}`