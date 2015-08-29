# -*- encoding: utf-8 -*-
# stub: flt 1.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "flt"
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Javier Goizueta"]
  s.date = "2015-04-06"
  s.description = "Decimal and binary arbitrary precision floating point numbers in pure Ruby."
  s.email = ["jgoizueta@gmail.com"]
  s.homepage = "http://github.com/jgoizueta/flt"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Floating Point Numbers"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.6"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.6"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.6"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
