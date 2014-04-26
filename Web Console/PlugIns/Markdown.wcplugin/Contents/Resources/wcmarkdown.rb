#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'
require 'listen'

require_relative "lib/controller"
require_relative "lib/window_manager"

if !ARGV.empty?
  file = ARGF.file
end
markdown = ARGF.read

window_manager = WcMarkdown::WindowManager.new

if !file
  WcMarkdown::Controller.new(window_manager, markdown)
  exit
end

filename = File.basename(file)
controller = WcMarkdown::Controller.new(window_manager, markdown, filename)

path = File.expand_path(File.dirname(file))

listener = Listen.to(path, only: /^#{Regexp.quote(filename)}$/) { |modified, added, removed| 
  file = File.open(modified[0])
  File.open(file) { |f| 
    controller.markdown = f.read
  }
}

listener.start

trap("SIGINT") {
  exit
}

sleep