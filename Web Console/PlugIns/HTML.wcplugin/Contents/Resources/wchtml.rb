#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'
require 'listen'

require_relative "lib/controller"

if !ARGV.empty?
  file = ARGF.file
end
html = ARGF.read

if !file
  window_manager = WebConsole::WindowManager.new
  WcMarkdown::Controller.new(window_manager, html)
  exit
end

filename = File.basename(file)
path = File.expand_path(File.dirname(file))

window_manager = WebConsole::WindowManager.new
window_manager.base_url_path = path
controller = WcHTML::Controller.new(window_manager, html)

listener = Listen.to(path, only: /(\.html$)|(\.css$)|(\.js$)/) { |modified, added, removed| 
  File.open(file) { |f| 
    controller.html = f.read
  }
}

listener.start

trap("SIGINT") {
  exit
}

sleep