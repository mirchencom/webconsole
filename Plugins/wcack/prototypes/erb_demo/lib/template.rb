require 'erb'

require './lib/model.rb'

module WcAck
  def self.render_files(files)
    template = ERB.new(File.new("./support/template.erb").read)

    puts template.result # prints "My name is Rasmus"
  end
end