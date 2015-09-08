require_relative "module"
require_relative "constants"

module WebConsole

  class Logger
    MESSAGE_PREFIX = 'MESSAGE '
    ERROR_PREFIX = 'ERROR '
    LOG_PLUGIN_NAME = 'Log'

    # Toggle

    SHOW_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "show_log.scpt")
    def show
      WebConsole::run_applescript(SHOW_LOG_SCRIPT, [window_id])
    end
    
    HIDE_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "hide_log.scpt")
    def hide
      WebConsole::run_applescript(HIDE_LOG_SCRIPT, [window_id])
    end
    
    TOGGLE_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "toggle_log.scpt")
    def toggle
      WebConsole::run_applescript(TOGGLE_LOG_SCRIPT, [window_id])
    end

    # Messages

    def info(message)
      message = message.dup
      message.gsub!(%r{^}, MESSAGE_PREFIX) # Prefix all lines
      # Strip trailing white space
      # Add a line break
      log_message(message)
    end

    def error(message)
      message = message.dup
      message.gsub!(%r{^}, ERROR_PREFIX)
      log_message(message)
    end

    # Properties

    def window_id
      if !@window_id
        if ENV.has_key?(WINDOW_ID_KEY)
          @window_id = ENV[WINDOW_ID_KEY]
        else
          @window_id = WebConsole::create_window
        end
      end
      return @window_id
    end
  
    def view_id
      if !@view_id
        # First see if there's an existing log plugin
        @view_id = WebConsole::split_id_in_window(window_id, LOG_PLUGIN_NAME)

        # If not, run one
        if !@view_id
          @view_id = WebConsole::split_id_in_window_last(window_id)
          WebConsole::run_plugin_in_split(LOG_PLUGIN_NAME, window_id, @view_id)
        end

      end

      return @view_id
    end

    private

    READ_FROM_STANDARD_INPUT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "read_from_standard_input.scpt")  
    def log_message(message)
      message.rstrip!
      message += "\n"
      WebConsole::run_applescript(READ_FROM_STANDARD_INPUT_SCRIPT, [message, window_id, view_id])
    end
  
  end
end
