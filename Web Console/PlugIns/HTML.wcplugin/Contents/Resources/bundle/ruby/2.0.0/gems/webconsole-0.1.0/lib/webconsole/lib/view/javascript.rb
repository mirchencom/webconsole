module WebConsole
  class View

    def do_javascript_function(function, arguments = nil)
      javascript = self.class.javascript_function(function, arguments)
      result = do_javascript(javascript)
      result.chomp!

      if result.is_integer?
        return result.to_i
      end

      if result.is_float?
        return result.to_f
      end

      return result
    end

    def self.javascript_function(function, arguments = nil)
      function = function.dup
      function << '('

      if arguments
        arguments.each { |argument|
          if argument
            function << argument.javascript_argument          
          else
            function << "null"
          end
          function << ', '
        }
        function = function[0...-2]
      end

      function << ');'

      return function
    end

    private

    class ::String
      def javascript_argument
        return "'#{self.javascript_escape}'"
      end

      def javascript_escape
        self.gsub('\\', "\\\\\\\\").gsub("\n", "\\\\n").gsub("'", "\\\\'")
      end

      def javascript_escape!
        replace(self.javascript_escape)
      end

      def is_float?
        !!Float(self) rescue false
      end

      def is_integer?
        self.to_i.to_s == self
      end
    end

    class ::Float
      def javascript_argument
        return self.to_s
      end
    end

    class ::Integer
      def javascript_argument
        return self.to_s
      end
    end

  end
end