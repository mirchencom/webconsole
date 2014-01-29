require 'webconsole'
require 'slim'

module WcGit
  class Controller < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.slim')

    def initialize(delegate = nil)
      @delegate = delegate

#       html = ERB.new(File.new(erb_template_path).read, nil, '-')
# :pretty => true
#       html = ERB.new(File.new(erb_template_path).read, nil, '-')

      # :pretty => true

      template_slim = Slim::Template.new(VIEW_TEMPLATE, :pretty => true)
      html = template_slim.render(self)

      # html = template_erb.result(binding)

      if @delegate
        @delegate.load_html(html)
      end
    end
  end
end