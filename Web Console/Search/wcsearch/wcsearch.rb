#!/usr/bin/env ruby

require 'Shellwords'
require 'webconsole'

SHARED_RESOURCES_PATH = WebConsole::resource_path_for_plugin("Shared Resources")
WEB_CONSOLE_CONSTANTS_FILE = File.join(SHARED_RESOURCES_PATH, "Shared/ruby/web_console_constants")
require WEB_CONSOLE_CONSTANTS_FILE

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")

CONSTANTS_FILE = File.join(LIB_DIRECTORY, "constants")
require CONSTANTS_FILE

PARSER_FILE = File.join(LIB_DIRECTORY, "parser")
require PARSER_FILE

CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(LIB_DIRECTORY, "window_manager")
require WINDOW_MANAGER_FILE


# Window Manager
window_id = ENV[WINDOW_ID_KEY]
window_manager = WcSearch::WindowManager.new(window_id)

# Parser
controller = WcSearch::Controller.new(window_manager)

if ARGV[1]
  directory = ARGV[1].dup
end
if !directory
  directory = `pwd`
end

parser = WcSearch::Parser.new(controller, directory)

# Parse
term = ARGV[0]
directory.chomp!

command = "#{SEARCH_COMMAND} #{Shellwords.escape(term)} #{Shellwords.escape(directory)}"
pipe = IO.popen(command)
while (line = pipe.gets)
  parser.parse_line(line)
end