$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "omise_shoppe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "omise_shoppe"
  s.version     = OmiseShoppe::VERSION
  s.authors     = ["nonmadden"]
  s.email       = ["nonmadden@gmail.com"]
  s.homepage    = "http://omise-shoppe.ohmpieng.co"
  s.summary     = "This gem is helper for shoppe and omise payment gateway"
  s.description = "This gem is helper for shoppe and omise payment gateway"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
