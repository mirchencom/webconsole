#!/usr/bin/env ruby

require 'erb'

TEMPLATE_DIRECTORY = File.join(File.dirname(__FILE__), '..','views')
VIEW_TEMPLATE = File.join(TEMPLATE_DIRECTORY, "view.html.erb")
template_erb = ERB.new(File.new(VIEW_TEMPLATE).read, nil, '-')
puts template_erb.result