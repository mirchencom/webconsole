require_relative '../../bundle/bundler/setup'
require 'slim'

module WebConsole::Git
  class View < WebConsole::View
    def load_slim_from_path(path)
      Slim::Engine.set_default_options :attr_delims => {'(' => ')', '[' => ']'} # Allow Handlebars syntax
      template_slim = Slim::Template.new(VIEW_TEMPLATE, :pretty => true)
      html = template_slim.render(self)
      load_html(html)
    end
  end
end