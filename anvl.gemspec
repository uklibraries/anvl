# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{anvl}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Beer"]
  s.summary = %q{Ruby ANVL implementation}
  s.date = %q{2011-06-12}
  s.email = %q{chris@cbeer.info}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Bundler will install these gems too if you've checked this out from source from git and run 'bundle install'
  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'yard'
end

