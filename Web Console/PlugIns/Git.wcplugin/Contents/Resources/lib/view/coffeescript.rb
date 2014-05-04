require_relative '../../bundle/bundler/setup'
require 'coffee-script'

module WebConsole::Git
  class View < WebConsole::View

    def do_coffeescript(coffeescript)
      javascript = CoffeeScript.compile(coffeescript)
      return do_javascript(javascript)
    end

  end
end