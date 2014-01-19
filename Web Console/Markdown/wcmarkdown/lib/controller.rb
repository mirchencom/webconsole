require 'webconsole'
require 'redcarpet'

module WcMarkdown
  class Controller < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil, markdown)
      @renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
      @html = @renderer.render(markdown)

      super(delegate, VIEW_TEMPLATE)
    end

    def body_content
      return @html
    end    

    def markdown=(markdown)
      puts @renderer.render(markdown)
      
      # TODO execute JavaScript to replace body with ruby
    end

  end
end