require 'webconsole'
require_relative 'tester'

module WcDependencies
  class Controller < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)
      super(delegate, VIEW_TEMPLATE)
    end

    ADD_MISSING_DEPENDENCY_FUNCTION = "addMissingDependency"
    def check(name, type, options = {})
      result = Tester::check(name, type)
      if result
        return
      end

      if options.has_key?(:installation_instructions)
        installation_instructions = options[:installation_instructions]
      end      

      type_string = self.class.string_for_type(type)
      javascript = self.class.javascript_function(ADD_MISSING_DEPENDENCY_FUNCTION, [name, type_string, installation_instructions])

      if @delegate
        @delegate.do_javascript(javascript)
      end

    end

    private

    def self.javascript_function(function, arguments)
      function = function.dup
      function << '('
      arguments.each { |argument|
        if argument
          function << argument.javascript_argument          
        else
          function << "null"
        end
        function << ', '
      }
      function = function[0...-2]
      function << ');'
      return function
    end

    class ::String
      def javascript_argument
        return "'#{self.javascript_escape}'"
      end
    end

    def self.string_for_type(type)
      case type
      when :shell_command
        return "shell command"
      end
      return nil
    end

    def title
      return ENV.has_key?(WebConsole::PLUGIN_NAME_KEY)? ENV[WebConsole::PLUGIN_NAME_KEY] : "Dependencies"
    end

  end
end