$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scorm2004/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scorm2004"
  s.version     = Scorm2004::VERSION
  s.authors     = ["Takahiro Noda"]
  s.email       = ["takahiro.noda+rubygems@gmail.com"]
  s.homepage    = "https://github.com/tnoda/scorm2004"
  s.summary     = "A mountable Rails engine that provides a SCORM 2004 sequencing engine."
  s.description = <<EOS
scorm2004 is a mountable Rails engine for Rails 3.2 applications.
It provides a sequencing engine for LMSs and supports SCORM 2004 4th Edition.
EOS

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency 'scorm2004-manifest'

  s.add_development_dependency "pg"
  s.add_development_dependency 'spork-testunit'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'factory_girl_rails'
end
