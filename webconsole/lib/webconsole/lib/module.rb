require 'Shellwords'
module WebConsole
  LOAD_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_plugin.scpt")
  def self.load_plugin(path)
    self.run_applescript(LOAD_PLUGIN_SCRIPT, [path])
  end

  EXISTS_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "exists.scpt")
  def self.application_exists
    result = self.run_applescript(EXISTS_SCRIPT)
    result.chomp!
    if result == "true"
      return true
    else
      return false
    end
  end

  RUN_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "run_plugin.scpt")
  def self.run_plugin(name, directory = nil, arguments = nil)
    parameters = [name]
    if directory
      parameters.push(directory)
    end
    if arguments
      parameters = parameters + arguments
    end
    result = self.run_applescript(RUN_PLUGIN_SCRIPT, parameters)
    result.chomp!
    return result
  end
  
  RUN_PLUGIN_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "run_plugin_in_split.scpt")
  def self.run_plugin_in_split(name, window_id, split_id)
    parameters = [name, window_id, split_id]
    result = self.run_applescript(RUN_PLUGIN_IN_SPLIT_SCRIPT, parameters)
    result.chomp!
    return result
  end

  PLUGIN_HAS_WINDOWS_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "plugin_has_windows.scpt")
  def self.plugin_has_windows(name)
    result = self.run_applescript(PLUGIN_HAS_WINDOWS_SCRIPT, [name])
    result.chomp!
    if result == "true"
      return true
    else
      return false
    end
  end

  WINDOW_ID_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "window_id_for_plugin.scpt")
  def self.window_id_for_plugin(name)
    result = self.run_applescript(WINDOW_ID_FOR_PLUGIN_SCRIPT, [name])
    result.chomp!
    return result
  end

  SPLIT_ID_IN_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "split_id_in_window.scpt")
  def self.split_id_in_window(window_id, pluginName = nil)
    arguments = [window_id]

    if pluginName
      arguments.push(pluginName)
    end

    result = self.run_applescript(SPLIT_ID_IN_WINDOW_SCRIPT, arguments)

    if result
      # TODO Remove this when doing `run_applescript` refactor
      result.chomp!
    end

    return result
  end

  SPLIT_ID_IN_WINDOW_LAST_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "split_id_in_window_last.scpt")
  def self.split_id_in_window_last(window_id)
    arguments = [window_id]
    result = self.run_applescript(SPLIT_ID_IN_WINDOW_LAST_SCRIPT, arguments)
    result.chomp!
    return result
  end

  CREATE_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "create_window.scpt")
  def self.create_window
    result = self.run_applescript(CREATE_WINDOW_SCRIPT)
    result.chomp!
    return result
  end

  # Shared Resources

  RESOURCE_PATH_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "resource_path_for_plugin.scpt")
  def self.resource_path_for_plugin(name)
    result = self.run_applescript(RESOURCE_PATH_FOR_PLUGIN_SCRIPT, [name])
    result.chomp!
    return result
  end

  # Shared Resource Path

  SHARED_RESOURCES_PLUGIN_NAME = "Shared Resources"
  SHARED_TEST_RESOURCES_PLUGIN_NAME = "Shared Test Resources"
  def self.shared_resources_path
    return resource_path_for_plugin(SHARED_RESOURCES_PLUGIN_NAME)
  end
  def self.shared_test_resources_path
    return resource_path_for_plugin(SHARED_TEST_RESOURCES_PLUGIN_NAME)
  end

  def self.shared_resource(resource)
    return File.join(self.shared_resources_path, resource)
  end
  def self.shared_test_resource(resource)
    return File.join(self.shared_test_resources_path, resource)    
  end

  # Shared Resource URL

  RESOURCE_URL_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "resource_url_for_plugin.scpt")
  def self.resource_url_for_plugin(name)
    result = self.run_applescript(RESOURCE_URL_FOR_PLUGIN_SCRIPT, [name])
    result.chomp!
    return result
  end
  def self.shared_resources_url
    return resource_url_for_plugin(SHARED_RESOURCES_PLUGIN_NAME)
  end

  private

  def self.run_applescript(script, arguments = nil)
    command = "osascript #{Shellwords.escape(script)}"
    if arguments
      arguments.each { |argument|
        if argument
          argument = argument.to_s
          command = command + " " + Shellwords.escape(argument)
        end
      }
    end

    result = `#{command}`
    if result.chomp.empty?
      return nil
    end
    return result
  end
end
