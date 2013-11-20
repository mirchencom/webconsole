#!/usr/bin/env ruby

require 'Shellwords'
require 'webconsole'

BASE_DIRECTORY = File.expand_path(File.dirname(__FILE__))
LIB_DIRECTORY = File.join(BASE_DIRECTORY, "lib")
PARSER_FILE = File.join(LIB_DIRECTORY, "parser")
require PARSER_FILE
CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

# Window Manager
window_id = ENV['WINDOWID']
window_manager = WebConsole::WindowManager.new(window_id)
BASE_PATH = File.expand_path(BASE_DIRECTORY)
window_manager.base_url_path = BASE_PATH

# Parser
parser = WcAck::Parser.new
parser.delegate = WcAck::Controller.new(window_manager)

# Parse
term = ARGV[0]
directory = `pwd`
directory.chomp!
pipe = IO.popen("ack --color #{Shellwords.escape(term)} #{Shellwords.escape(directory)}")
while (line = pipe.gets)
  parser.parse_line(line)
end