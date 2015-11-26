module WebConsole::Markdown
  class View < WebConsole::View

    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(html = nil, filename = nil)
      super()
      @html = html
      @filename = filename
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      load_erb_from_path(VIEW_TEMPLATE)
    end

    def body
      return @html
    end    

    def title
      return @filename if @filename
      super
    end

    REPLACE_CONTENT_JAVASCRIPT_FUNCTION = "replaceContent"
    def html=(html)
      do_javascript_function(REPLACE_CONTENT_JAVASCRIPT_FUNCTION, [html])
    end

  end

end