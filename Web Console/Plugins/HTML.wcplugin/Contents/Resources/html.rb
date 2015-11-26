#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'
require 'listen'

require_relative "lib/controller"

file = ARGF.file unless ARGV.empty?

html = ARGF.read

# This should allow the plugin to process HTML from stdin, but
# the Web Console Application doesn't yet support running a plugin
# and reading from stdin simultaneously
# if !file
#   window = WebConsole::Window.new
#   WebConsole::Controller.new(window, html)
#   exit
# end

filename = File.basename(file)
path = File.expand_path(File.dirname(file))

window = WebConsole::Window.new
window.base_url_path = path
controller = WebConsole::HTML::Controller.new(window, html)

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