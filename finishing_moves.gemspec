$:.push File.expand_path("../lib", __FILE__)

require "finishing_moves/version"

Gem::Specification.new do |s|

  s.name        = "finishing_moves"
  s.version     = FinishingMoves::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frank Koehl", "Chris Tonkinson"]
  s.email       = ["frank@forgecrafted.com", "chris@forgecrafted.com"]
  s.summary     = %q{A few clutch expansions to core Ruby}
  s.description = %q{A collection of nice-to-have expansions to core Ruby libraries. Written to follow the "do one job very well" Unix philosophy. When you need them, you'll be happy you have them.}
  s.homepage    = "https://github.com/forgecrafted/finishing_moves"
  s.license     = "MIT"

  s.files       = `git ls-files -z`.split("\x0")
  s.test_files  = Dir["spec/**/*"]

  s.add_development_dependency 'rb-readline'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'priscilla'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'fuubar'

end
