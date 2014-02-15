#!/usr/bin/env ruby

require 'Shellwords'
require 'webconsole'

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")

PARSER_FILE = File.join(LIB_DIRECTORY, "parser")
require PARSER_FILE

CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(LIB_DIRECTORY, "window_manager")
require WINDOW_MANAGER_FILE


# Window Manager
window_id = ENV['WINDOWID']
window_manager = WcAck::WindowManager.new(window_id)

# Parser
controller = WcAck::Controller.new(window_manager)

if ARGV[1]
  directory = ARGV[1].dup
end
if !directory
  directory = `pwd`
end

parser = WcAck::Parser.new(controller, directory)

# Parse
term = ARGV[0]
directory.chomp!

# TODO Getting stuck here when run as a plugin, why? If I can fix ack in TextMate it should work here
pipe = IO.popen("ack --color #{Shellwords.escape(term)} #{Shellwords.escape(directory)}")
while (line = pipe.gets)
  parser.parse_line(line)
end