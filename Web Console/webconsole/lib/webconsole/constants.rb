WC_WINDOW_ID_KEY = 'WC_WINDOW_ID'
WC_SHARED_RESOURCES_PATH_KEY = 'WC_SHARED_RESOURCES_PATH'
WC_SHARED_RESOURCES_URL_KEY = 'WC_SHARED_RESOURCES_URL'

module WebConsole
  WINDOW_MANAGER_FILE = File.join(File.dirname(__FILE__), "window_manager")
  CONTROLLER_FILE = File.join(File.dirname(__FILE__), "controller")
  MODULE_FILE = File.join(File.dirname(__FILE__), "module")
  APPLESCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), "..", "applescript")
end