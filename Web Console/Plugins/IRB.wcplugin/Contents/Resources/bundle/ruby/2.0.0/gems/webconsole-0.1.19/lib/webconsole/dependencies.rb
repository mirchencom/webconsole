require_relative 'extension_constants'
require WEBCONSOLE_FILE

module WebConsole::Dependencies
  class Checker
    require_relative 'dependencies/lib/model'
    require_relative 'dependencies/lib/controller'

    def check_dependencies(dependencies)
      passed = true
      dependencies.each { |dependency|  
        dependency_passed = check(dependency)
        passed = false unless dependency_passed
      }
      passed
    end

    def check(dependency)
      name = dependency.name
      type = dependency.type
      passed = Tester::check(name, type)
      controller.missing_dependency(dependency) unless passed
      passed
    end

    private

    def controller
      @controller ||= Controller.new
    end

  end

end