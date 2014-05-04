module WebConsole
  class View
    require 'open-uri'

    require_relative "../constants"
    require_relative "../module"

    attr_accessor :title
    
    CSS_EXTENSION = ".css"
    CSS_PATH_COMPONENT = "css/"
    def shared_stylesheet_link_tag(resource)
      uri = URI.join(shared_resources_url, CSS_PATH_COMPONENT, resource + CSS_EXTENSION)
      return stylesheet_link_tag(uri.to_s)
    end

    def stylesheet_link_tag(url)
      return "<link rel=\"stylesheet\" href=\"#{url}\" />"
    end

    JS_EXTENSION = ".js"
    JS_PATH_COMPONENT = "js/"
    def shared_javascript_include_tag(resource)
      uri = URI.join(shared_resources_url, JS_PATH_COMPONENT, resource + JS_EXTENSION)
      return javascript_include_tag(uri.to_s)
    end

    def javascript_include_tag(url)
      return "<script type=\"text/javascript\" src=\"#{url}\"></script>"
    end

    def title
      if !@title && ENV.has_key?(PLUGIN_NAME_KEY)
        @title = ENV[PLUGIN_NAME_KEY]
      end
      return @title
    end

    private

    def shared_resources_url
      if !@shared_resources_url
        @shared_resources_url = ENV.has_key?(SHARED_RESOURCES_URL_KEY)? ENV[SHARED_RESOURCES_URL_KEY] : WebConsole::shared_resources_url
      end
      return @shared_resources_url
    end
  end
end