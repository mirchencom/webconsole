require 'erb'
require 'open-uri'

module WebConsole
  class Controller
    require_relative "constants"
    require_relative "module"

    attr_reader :name
    def initialize(delegate = nil, erb_template_path = nil)
      @delegate = delegate

      template_erb = ERB.new(File.new(erb_template_path).read, nil, '-')
      html = template_erb.result(binding)

      if @delegate
        @delegate.load_html(html)
      end
    end

    CSS_EXTENSION = ".css"
    CSS_PATH_COMPONENT = "css/"
    def shared_stylesheet_link_tag(resource)
      uri = URI.join(shared_resources_url, CSS_PATH_COMPONENT, resource + CSS_EXTENSION)
      return "<link rel=\"stylesheet\" href=\"#{uri.to_s}\" />"
    end
    JS_EXTENSION = ".js"
    JS_PATH_COMPONENT = "js/"
    def shared_javascript_include_tag(resource)
      uri = URI.join(shared_resources_url, JS_PATH_COMPONENT, resource + JS_EXTENSION)
      return "<script type=\"text/javascript\" src=\"#{uri.to_s}\"></script>"
    end
    
    private

    def shared_resources_url
      if !@shared_resources_url
        @shared_resources_url = ENV.has_key?(SHARED_RESOURCES_URL_KEY)? ENV[SHARED_RESOURCES_URL_KEY] : WebConsole::shared_resources_url
      end
      return @shared_resources_url
    end

    class ::String
      def javascript_escape
        self.gsub('\\', "\\\\\\\\").gsub("\n", "\\\\n").gsub("'", "\\\\'")
      end

      def javascript_escape!
        replace(self.javascript_escape)
      end
    end

  end
end