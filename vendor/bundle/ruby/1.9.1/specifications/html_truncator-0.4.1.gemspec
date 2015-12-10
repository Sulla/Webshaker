# -*- encoding: utf-8 -*-
# stub: html_truncator 0.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "html_truncator"
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bruno Michel"]
  s.date = "2015-03-12"
  s.description = "Wants to truncate an HTML string properly? This gem is for you."
  s.email = "bmichel@menfin.info"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/nono/HTML-Truncator"
  s.rubygems_version = "2.4.3"
  s.summary = "Wants to truncate an HTML string properly? This gem is for you."

  s.installed_by_version = "2.4.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.5"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.5"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
