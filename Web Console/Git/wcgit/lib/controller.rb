require 'webconsole'
require 'slim'

module WcGit


  class Controller < WebConsole::Controller

    attr_accessor :branch

    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.slim')
    def initialize(delegate = nil)
      @delegate = delegate

      Slim::Engine.set_default_options :attr_delims => {'(' => ')', '[' => ']'} # Allow Handlebars syntax
      template_slim = Slim::Template.new(VIEW_TEMPLATE, :pretty => true)
      html = template_slim.render(self)

      if @delegate
        @delegate.load_html(html)
      end
    end

    def branch
      branch = nil
      if @delegate
        coffeescript = "return wcGit.branch"
        branch = @delegate.do_coffeescript(coffeescript)
      end
      return branch
    end

    def branch=(value)
      if @delegate
        coffeescript = "wcGit.branch = '#{value.javascript_escape}'"
        @delegate.do_coffeescript(coffeescript)
      end
    end
  end
end