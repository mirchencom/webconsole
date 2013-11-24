require 'webconsole'

WINDOW_MANAGER_DIRECTORY = File.expand_path(File.dirname(__FILE__))
BASE_DIRECTORY = File.join(WINDOW_MANAGER_DIRECTORY, '..')

module WcAck
  class WindowManager < WebConsole::WindowManager
    def initialize(window_id = nil)
      super(window_id)
      base_url_path = File.expand_path(BASE_DIRECTORY)
    end    
  end
end