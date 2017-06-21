$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "shoppe/omise/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shoppe-omise"
  s.version     = Shoppe::Omise::VERSION
  s.authors     = ["Arnon Hongklay"]
  s.email       = ["arnon@hongklay.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Shoppe::Omise."
  s.description = "TODO: Description of Shoppe::Omise."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.1"

  s.add_development_dependency "pg"
end
