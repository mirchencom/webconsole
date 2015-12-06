require_relative 'constants'
require_relative 'runner'

class Window

  def initialize(window_id = nil)
    @window_id = window_id
    @base_url = "file://" + File.join(File.dirname(__FILE__), "../resources")
  end

  def window_id
    @window_id ||= Runner::create_window
  end

  LOADHTMLWITHBASEURL_SCRIPT_1 = File.join(APPLESCRIPT_DIRECTORY, "load_html_with_base_url_1.scpt")
  def load_html_1(html)
    arguments = [html, @base_url]
    run_script(LOADHTMLWITHBASEURL_SCRIPT_1, arguments)
  end

  LOADHTMLWITHBASEURL_SCRIPT_2 = File.join(APPLESCRIPT_DIRECTORY, "load_html_with_base_url_2.scpt")
  def load_html_2(html)
    run_script(LOADHTMLWITHBASEURL_SCRIPT_2, [@base_url], html)
  end

  DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "do_javascript.scpt")
  def do_javascript(javascript)
    run_script(DOJAVASCRIPT_SCRIPT, [javascript])
  end

  CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "close_window.scpt")
  def close
    Runner::run_applescript(CLOSEWINDOW_SCRIPT, [window_id])
  end

  # Private

  def run_script(script, arguments = [], input = nil)
    arguments = arguments_with_target(arguments)
    Runner::run_applescript(script, arguments, input)
  end

  def arguments_with_target(arguments)
    arguments.push(window_id)
  end

end