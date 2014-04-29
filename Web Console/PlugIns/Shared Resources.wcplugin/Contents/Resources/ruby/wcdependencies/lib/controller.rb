require 'webconsole'

require_relative 'tester'
require_relative 'model'
require_relative 'view'

module WcDependencies

  class Controller

    attr_reader :view
    def initialize
      @view = View.new
    end

    def missing_dependency(dependency)
      name = dependency.name
      type = self.class.string_for_type(dependency.type)
      options = dependency.options

      if options.has_key?(:installation_instructions)
        installation_instructions = options[:installation_instructions]
      end      

      @view.add_missing_dependency(name, type, installation_instructions)
    end

    private

    def self.string_for_type(type)
      case type
      when :shell_command
        return "shell command"
      end
      return nil
    end

  end
end