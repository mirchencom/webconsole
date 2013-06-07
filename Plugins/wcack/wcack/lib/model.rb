module WcAck
  module Match
    class File
      attr_reader :path, :lines
      def initialize(path)
        @path = path
        @lines = Array.new
      end

      class Line
        attr_reader :line_number, :matches
        attr_accessor :text
        def initialize(line_number)
          @line_number = line_number
          @matches = Array.new
        end

        class Match
          attr_reader :index, :length
          def initialize(index, length)
            @index = index
            @length = length
          end
        end

      end
    end
  end
end