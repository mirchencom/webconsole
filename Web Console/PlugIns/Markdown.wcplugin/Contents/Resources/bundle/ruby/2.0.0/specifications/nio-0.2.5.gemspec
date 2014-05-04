# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nio"
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Javier Goizueta"]
  s.date = "2010-05-31"
  s.description = "Numeric input/output"
  s.email = "javier@goizueta.info"
  s.extra_rdoc_files = ["History.txt", "License.txt", "README.txt", "SOURCE.txt"]
  s.files = ["History.txt", "License.txt", "README.txt", "SOURCE.txt"]
  s.homepage = "http://nio.rubyforge.org"
  s.rdoc_options = ["--main", "README.txt", "--title", "Nio Documentation", "--opname", "index.html", "--line-numbers", "--inline-source", "--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "nio"
  s.rubygems_version = "2.0.3"
  s.summary = "Numeric input/output"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<flt>, [">= 1.0.0"])
      s.add_development_dependency(%q<bones>, [">= 2.1.1"])
    else
      s.add_dependency(%q<flt>, [">= 1.0.0"])
      s.add_dependency(%q<bones>, [">= 2.1.1"])
    end
  else
    s.add_dependency(%q<flt>, [">= 1.0.0"])
    s.add_dependency(%q<bones>, [">= 2.1.1"])
  end
end
