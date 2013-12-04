require 'webconsole'

module WcAck
  class WindowManager < WebConsole::WindowManager
    WINDOW_MANAGER_DIRECTORY = File.dirname(__FILE__)
    BASE_DIRECTORY = File.join(WINDOW_MANAGER_DIRECTORY, '..')

    def initialize(window_id = nil)
      super(window_id)
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
    end
  end
end