#!/usr/bin/env ruby

require 'webconsole'

BASE_DIRECTORY = File.join(File.dirname(__FILE__))
LIB_DIRECTORY = File.join(BASE_DIRECTORY, "lib")
PARSER_FILE = File.join(LIB_DIRECTORY, "parser")
require PARSER_FILE
CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE
# WEBCONSOLE_FILE = File.join(BASE_DIRECTORY, "..", "webconsole", "webconsole")
# require WEBCONSOLE_FILE

# Web Console
BASE_PATH = File.expand_path(BASE_DIRECTORY)
webconsole = WebConsole.new
webconsole.base_url_path = BASE_PATH

# Parser
parser = WcAck::Parser.new
parser.delegate = WcAck::Controller.new(webconsole)
parser.parse(ARGF.read)