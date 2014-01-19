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
      @html = @renderer.render(markdown)
      # @html.strip!

javascript = "replaceContent('#{@html.javascript_escape}');"

# Doesn't work
#       javascript = %Q[replaceContent('blah blah
#         blah bha
# ');]

# javascript = javascript.gsub("\n", "\\\\\n")


# Works?
      # javascript = %Q[replaceContent('blah blah');]

      if @delegate
        @delegate.do_javascript(javascript)
      end
    end

    class ::String
      def javascript_escape
        self.gsub('\\', "\\\\\\\\").gsub("\n", "\\\\\n").gsub("'", "\\\\'")
      end

      def javascript_escape!
        replace(self.javascript_escape)
      end
    end

  end
end