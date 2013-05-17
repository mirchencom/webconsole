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
        def initialize(line_number)
          @line_number = line_number
          @matches = Array.new
        end

        class Match
          attr_reader :start, :length
          def initialize(start, length)
            @start = start
            @length = length
          end
        end

      end
    end
  end
end