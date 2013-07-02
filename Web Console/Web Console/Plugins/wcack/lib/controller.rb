require 'erb'


# Controller has a delegate, either domrunner or WebConsole
module WcAck
  class Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    attr_writer :delegate
    def initialize(delegate)
      @delegate = delegate

      view_erb = ERB.new(File.new(VIEW_TEMPLATE).read, nil, '-')
      html = view_erb.result
      @delegate.load_html(html)
    end

    def added_file(file)
      javascript = "addFile('#{file.file_path}');"
      @delegate.do_javascript(javascript)
    end

    def added_line_to_file(line, file)
      matches_javascript = ""
      line.matches.each { |match|
        match_javascript = %Q[ 
  {
    index: #{match.index},
    length: #{match.length}
  },]
        matches_javascript << match_javascript
      }
      matches_javascript.chomp!(",");
      javascript = %Q[
var matches = [#{matches_javascript}  
];
addLine(#{line.number}, '#{line.text}', matches);
]
      @delegate.do_javascript(javascript)
    end
  end    
end




# javascript = %Q[
# var matches = [
#   {
#     index: 24,
#     length: 10
#   },
#   {
#     index: 136,
#     length: 10
#   }
# ];
# addFile('#{file.file_path}');
# addLine(10, '#{text}', matches);
# addLine(20, '#{text}', matches);
# addFile('#{file.file_path}');
# addLine(30, '#{text}', matches);
# ]
