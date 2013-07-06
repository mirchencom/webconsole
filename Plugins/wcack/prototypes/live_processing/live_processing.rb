#!/usr/bin/env ruby

require 'Shellwords'

term = ARGV[0]

pipe = IO.popen("ack --color #{Shellwords.escape(term)}")
while (line = pipe.gets)
  print line
  print "and"
end