module WebConsole
  # Keys
  PLUGIN_NAME_KEY = 'WC_PLUGIN_NAME'
  WINDOW_ID_KEY = 'WC_WINDOW_ID'
  SHARED_RESOURCES_PATH_KEY = 'WC_SHARED_RESOURCES_PATH'
  SHARED_RESOURCES_URL_KEY = 'WC_SHARED_RESOURCES_URL'

  # Files
  WINDOW_MANAGER_FILE = File.join(File.dirname(__FILE__), "window_manager")
  CONTROLLER_FILE = File.join(File.dirname(__FILE__), "controller")
  MODULE_FILE = File.join(File.dirname(__FILE__), "module")
  
  # Directories
  APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "..", "applescript")
end