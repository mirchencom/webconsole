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
        if !dependency_passed
          passed = false
        end
      }
      return passed
    end

    def check(dependency)
      name = dependency.name
      type = dependency.type
      passed = Tester::check(name, type)
      if !passed
        controller.missing_dependency(dependency)
      end
      return passed
    end

    private

    def controller
      if !@controller
        @controller = Controller.new
      end
      return @controller
    end

  end

end