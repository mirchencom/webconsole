#!/usr/bin/env ruby

require 'redcarpet'
require 'webconsole'

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")

CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE


markdown = ARGF.read

window_manager = WebConsole::WindowManager.new
controller = WcMarkdown::Controller.new(window_manager, markdown)


# TODO Setup refresh by using the below

if !ARGV.empty?
  file = ARGF.file
end

# if file
#   puts "From " + file.path
# else
#   puts "From STDIN"
# end

