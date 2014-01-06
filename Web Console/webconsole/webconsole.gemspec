Gem::Specification.new do |s|
  s.name        = 'webconsole'
  s.version     = '0.0.0'
  s.date        = '2013-07-04'
  s.summary     = "Web Console helper gem"
  s.description = "Bridge from Ruby to AppleScript to control Web Console"
  s.authors = ["Roben Kleene"]
  s.email = 'roben@1percenter.com'
  s.files = %w[
    lib/webconsole.rb
    lib/webconsole/constants.rb
    lib/webconsole/controller.rb
    lib/webconsole/module.rb
    lib/webconsole/window_manager.rb
    lib/applescript/resource_path_for_plugin.scpt
    lib/applescript/resource_url_for_plugin.scpt
    lib/applescript/close_window.scpt
    lib/applescript/do_javascript.scpt
    lib/applescript/load_html.scpt
    lib/applescript/run_plugin.scpt
    lib/applescript/load_plugin.scpt
    lib/applescript/plugin_has_windows.scpt
    lib/applescript/plugin_read_from_standard_input.scpt
    lib/applescript/window_id_for_plugin.scpt
  ]
end