module WebConsole::Git
  class View < WebConsole::View
    require_relative "view/slim"
    require_relative "view/coffeescript"

    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.slim')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      load_slim_from_path(VIEW_TEMPLATE)
    end

# TODO Implement do_coffeescript_function helper similar to do_javascript_function

    def branch_name
      coffeescript = "return wcGit.branchName"
      branch_name = do_coffeescript(coffeescript)
      branch_name.chomp!
      if branch_name.empty?
        branch_name = nil
      end
      return branch_name
    end

    def branch_name=(value)
      value ||= "" # Handle nil
      coffeescript = "wcGit.branchName = '#{value.javascript_escape}'"
      do_coffeescript(coffeescript)
    end

  end
end