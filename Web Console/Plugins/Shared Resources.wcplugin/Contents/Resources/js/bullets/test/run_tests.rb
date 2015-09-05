#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require 'Shellwords'

HTML_FILE = File.join(File.dirname(__FILE__), "lib/index.html")

exec("mocha-phantomjs #{Shellwords.escape(HTML_FILE)}")