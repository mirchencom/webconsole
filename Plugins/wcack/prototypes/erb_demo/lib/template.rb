require 'erb'

require File.join(File.dirname(__FILE__), 'model')

module WcAck
  def self.render_files(files)
    template_file = File.new(File.join(File.dirname(__FILE__), '..', 'support', 'template.erb'))
    template = ERB.new(template_file.read, nil, '-')
    # template = ERB.new(File.new("./support/template.erb").read, nil, '-')

    puts template.result # prints "My name is Rasmus"
  end
end