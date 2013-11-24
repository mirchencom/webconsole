#!/usr/bin/env ruby

require 'Shellwords'
require 'webconsole'

SCRIPT_DIRECTORY = File.expand_path(File.dirname(__FILE__))
LIB_DIRECTORY = File.join(SCRIPT_DIRECTORY, "lib")

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
parser = WcAck::Parser.new(WcAck::Controller.new(window_manager))

# Parse
term = ARGV[0]
directory = `pwd`
directory.chomp!
pipe = IO.popen("ack --color #{Shellwords.escape(term)} #{Shellwords.escape(directory)}")
while (line = pipe.gets)
  parser.parse_line(line)
end