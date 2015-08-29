module WebConsole
  class View

    require 'erb'

    def load_erb_from_path(path)
      erb = File.new(path).read
      load_erb(erb)
    end

    def load_erb(erb)
      template = ERB.new(erb, nil, '-')
      html = template.result(binding)
      load_html(html)
    end
  end
end