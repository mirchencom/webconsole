module WebConsole
  require_relative "webconsole/lib/constants"
  require_relative "webconsole/lib/window"
  require_relative "webconsole/lib/controller"
  require_relative "webconsole/lib/view"
  require_relative "webconsole/lib/logger"
  require_relative "webconsole/lib/module"
end

WebConsole::application_exists || abort("The Web Console application is not installed.")