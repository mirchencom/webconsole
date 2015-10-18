module WebConsole
  class View < Window

    def do_javascript_function(function, arguments = nil)
      javascript = self.class.javascript_function(function, arguments)
      return do_javascript(javascript)
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
    end

  end
end