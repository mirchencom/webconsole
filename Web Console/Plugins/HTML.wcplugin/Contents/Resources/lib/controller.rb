module WebConsole::HTML
  class Controller

    def initialize(delegate = nil, html)
      @delegate = delegate
      @delegate.load_html(html) if @delegate
    end

    def html=(html)
      @delegate.load_html(html) if @delegate
    end

  end
end