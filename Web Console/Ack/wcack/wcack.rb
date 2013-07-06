#!/usr/bin/env ruby

require 'webconsole'

BASE_DIRECTORY = File.join(File.dirname(__FILE__))
LIB_DIRECTORY = File.join(BASE_DIRECTORY, "lib")
PARSER_FILE = File.join(LIB_DIRECTORY, "parser")
require PARSER_FILE
CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

# Window Manager
BASE_PATH = File.expand_path(BASE_DIRECTORY)
window_manager = WebConsole::WindowManager.new
window_manager.base_url_path = BASE_PATH

# Parser
parser = WcAck::Parser.new
parser.delegate = WcAck::Controller.new(window_manager)
parser.parse(ARGF.read)