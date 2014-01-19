#!/usr/bin/env ruby

require 'webconsole'
require 'listen'

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")

CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

if !ARGV.empty?
  file = ARGF.file
end

markdown = ARGF.read

window_manager = WebConsole::WindowManager.new
controller = WcMarkdown::Controller.new(window_manager, markdown)

exit if !file

path = File.expand_path(File.dirname(file))
filename = File.basename(file)

listener = Listen.to(path, only: /^#{Regexp.quote(filename)}$/) { |modified, added, removed| 
  file = File.open(modified[0])
  controller.markdown = file.read
}

listener.start

trap("SIGINT") {
  exit
}

sleep