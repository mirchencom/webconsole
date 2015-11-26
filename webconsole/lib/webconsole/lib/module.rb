require 'Shellwords'
module WebConsole
  LOAD_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "load_plugin.scpt")
  def self.load_plugin(path)
    self.run_applescript(LOAD_PLUGIN_SCRIPT, [path])
  end

  EXISTS_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "exists.scpt")
  def self.application_exists
    result = self.run_applescript(EXISTS_SCRIPT)
    result == "true" ? true : false
  end

  RUN_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "run_plugin.scpt")
  def self.run_plugin(name, directory = nil, arguments = nil)
    parameters = [name]
    parameters.push(directory) unless directory.nil?
    parameters += arguments unless arguments.nil?
    self.run_applescript(RUN_PLUGIN_SCRIPT, parameters)
  end
  
  RUN_PLUGIN_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "run_plugin_in_split.scpt")
  def self.run_plugin_in_split(name, window_id, split_id)
    parameters = [name, window_id, split_id]
    self.run_applescript(RUN_PLUGIN_IN_SPLIT_SCRIPT, parameters)
  end

  WINDOW_ID_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "window_id_for_plugin.scpt")
  def self.window_id_for_plugin(name)
    self.run_applescript(WINDOW_ID_FOR_PLUGIN_SCRIPT, [name])
  end

  SPLIT_ID_IN_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "split_id_in_window.scpt")
  def self.split_id_in_window(window_id, pluginName = nil)
    arguments = [window_id]
    arguments.push(pluginName) unless pluginName.nil?
    self.run_applescript(SPLIT_ID_IN_WINDOW_SCRIPT, arguments)
  end

  SPLIT_ID_IN_WINDOW_LAST_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "split_id_in_window_last.scpt")
  def self.split_id_in_window_last(window_id)
    arguments = [window_id]
    self.run_applescript(SPLIT_ID_IN_WINDOW_LAST_SCRIPT, arguments)
  end

  CREATE_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "create_window.scpt")
  def self.create_window
    self.run_applescript(CREATE_WINDOW_SCRIPT)
  end

  # Shared Resources

  RESOURCE_PATH_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "resource_path_for_plugin.scpt")
  def self.resource_path_for_plugin(name)
    self.run_applescript(RESOURCE_PATH_FOR_PLUGIN_SCRIPT, [name])
  end

  # Shared Resource Path

  SHARED_RESOURCES_PLUGIN_NAME = "Shared Resources"
  SHARED_TEST_RESOURCES_PLUGIN_NAME = "Shared Test Resources"
  def self.shared_resources_path
    resource_path_for_plugin(SHARED_RESOURCES_PLUGIN_NAME)
  end
  def self.shared_test_resources_path
    resource_path_for_plugin(SHARED_TEST_RESOURCES_PLUGIN_NAME)
  end

  def self.shared_resource(resource)
    File.join(self.shared_resources_path, resource)
  end
  def self.shared_test_resource(resource)
    File.join(self.shared_test_resources_path, resource)    
  end

  # Shared Resource URL

  RESOURCE_URL_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "resource_url_for_plugin.scpt")
  def self.resource_url_for_plugin(name)
    self.run_applescript(RESOURCE_URL_FOR_PLUGIN_SCRIPT, [name])
  end
  def self.shared_resources_url
    resource_url_for_plugin(SHARED_RESOURCES_PLUGIN_NAME)
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

    result.chomp!

    if result.empty?
      return nil
    end

    if result.is_integer?
      return result.to_i
    end

    if result.is_float?
      return result.to_f
    end

    return result
  end

  class ::String
    def is_float?
      true if Float(self) rescue false
    end

    def is_integer?
      self.to_i.to_s == self
    end
  end

  class ::Float
    alias_method :javascript_argument, :to_s
  end

  class ::Integer
    alias_method :javascript_argument, :to_s
  end

end
