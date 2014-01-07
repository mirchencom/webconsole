module WebConsole
  WEBCONSOLE_CONSTANTS = File.join(File.dirname(__FILE__), "webconsole", "constants")
  require WEBCONSOLE_CONSTANTS
  require WINDOW_MANAGER_FILE
  require CONTROLLER_FILE
  require MODULE_FILE
end