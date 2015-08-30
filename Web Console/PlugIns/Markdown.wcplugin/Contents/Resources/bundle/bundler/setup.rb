require 'rbconfig'
# ruby 1.8.7 doesn't define RUBY_ENGINE
ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
ruby_version = RbConfig::CONFIG["ruby_version"]
path = File.expand_path('..', __FILE__)
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.0.0-static/ffi-1.9.10")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/ffi-1.9.10/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/flt-1.5.0/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/rb-fsevent-0.9.5/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/rb-inotify-0.9.5/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/listen-3.0.3/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/nio-0.2.5/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.0.0-static/redcarpet-3.3.2")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/redcarpet-3.3.2/lib")
$:.unshift File.expand_path("#{path}/../#{ruby_engine}/#{ruby_version}/gems/webconsole-0.1.10/lib")
