Gem::Specification.new do |s|
  s.name        = 'webconsole'
  s.version     = '0.1.12'
  s.date        = '2013-07-04'
  s.summary     = "Web Console helper gem"
  s.description = "Bridge from Ruby to AppleScript to control Web Console"
  s.authors = ["Roben Kleene"]
  s.email = 'roben@1percenter.com'
  s.required_ruby_version = '~> 2.0'
  s.files = Dir.glob("lib/**/*").reject { |f| 
    f['lib/webconsole/repl/test'] ||
    f['lib/webconsole/dependencies/test'] 
  }
end
