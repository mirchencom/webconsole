require_relative 'lib/model'

module WcDependencies
  class Checker
    require_relative 'lib/controller'

    attr_reader :window_manager

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
        @window_manager = WindowManager.new
        @controller = Controller.new(window_manager)
      end
      return @controller
    end

  end

end