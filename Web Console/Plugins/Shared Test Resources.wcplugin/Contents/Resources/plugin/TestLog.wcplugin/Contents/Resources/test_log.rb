#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'
require 'webconsole/logger'

logger = WebConsole::Logger.new
logger.info("Testing log message")
puts "Testing print to standard input"
STDERR.puts "Testing print to standard error"
window = WebConsole::Window.new
window.do_javascript("document.body.innerHTML = \"test\";")
logger.error("Testing log error")
logger.show