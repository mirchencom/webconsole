#!/usr/bin/env ruby

require 'webconsole'

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")
CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

# Window Manager
window_manager = WebConsole::WindowManager.new
BASE_PATH = File.expand_path(File.dirname(__FILE__))
window_manager.base_url_path = BASE_PATH

# Controller
controller = WcData::Controller.new(window_manager)

PATH_KEY = "Path"
path = Dir.pwd.to_s
controller.add_key_value(PATH_KEY, path)

ARGUMENTS_KEY = "Arguments"
arguments = ARGV.join(" ")
controller.add_key_value(ARGUMENTS_KEY, arguments)


# Debugging
path_value = controller.value_for_key(PATH_KEY)
puts "path_value = " + path_value.to_s

arguments_value = controller.value_for_key(ARGUMENTS_KEY)
puts "arguments_value = " + arguments_value.to_s

