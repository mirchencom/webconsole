require_relative '../bundle/bundler/setup'
require 'webconsole'

module WcSearch
  class View < WebConsole::View
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), '..')
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      self.load_erb_from_path(VIEW_TEMPLATE)
    end
  end
end