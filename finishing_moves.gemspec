$:.push File.expand_path("../lib", __FILE__)

require "finishing_moves/version"

Gem::Specification.new do |s|

  s.name        = "finishing_moves"
  s.version     = FinishingMoves::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frank Koehl"]
  s.email       = ["battlebrisket@outlook.com"]
  s.summary     = %q{Incredibly useful methods added to core Ruby classes. Includes the endlessly useful nil_chain.}
  s.description = <<-EOF
    Ruby includes a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself performing contortions to achieve results that, honestly, should feel more natural given the language's design elegance. Finishing Moves is a collection of methods designed to assist in those "why is this awkward?" scenarios.
  EOF
  s.homepage    = "https://github.com/battlebrisket/finishing_moves"
  s.license     = "MIT"

  s.files       = `git ls-files -z`.split("\x0")
  s.test_files  = Dir["spec/**/*"]

  s.add_development_dependency 'rspec', '~> 3.13.0'
  s.add_development_dependency 'fuubar', '>= 0'
  s.add_development_dependency 'coveralls_reborn', '>= 0'

  s.required_ruby_version = '>= 2.7.0'

end
