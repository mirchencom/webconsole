class ParsedLine
  attr_reader :file_path, :line_number

  ANSI_ESCAPE = '\x1b[^m]*m'
  ANSI_WRAPPER_REGEXP = Regexp.new("#{ANSI_ESCAPE}" + '(.+?)' + "#{ANSI_ESCAPE}")
  METADATA_REGEXP = Regexp.new(ANSI_WRAPPER_REGEXP.source + ":#{ANSI_ESCAPE}[0-9]+#{ANSI_ESCAPE}:")

  def initialize(line)
puts "line = " + line.to_s


    ansi_wrapped = line.scan(ANSI_WRAPPER_REGEXP)
    @file_path = ansi_wrapped[0][0]
    @line_number = ansi_wrapped[1][0].to_i

puts "ansi_wrapped = " + ansi_wrapped.to_s


    match = line.sub(METADATA_REGEXP, '')

    puts match.inspect
  end
end