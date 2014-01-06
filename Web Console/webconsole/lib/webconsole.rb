WC_WEBCONSOLE_CONSTANTS = File.join(File.dirname(__FILE__), "webconsole", "constants")
require WC_WEBCONSOLE_CONSTANTS

module WebConsole
  require WINDOW_MANAGER_FILE
  require CONTROLLER_FILE
  require MODULE_FILE
end