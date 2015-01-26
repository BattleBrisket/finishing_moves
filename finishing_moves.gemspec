$:.push File.expand_path("../lib", __FILE__)

require "finishing_moves/version"

Gem::Specification.new do |s|

  s.name        = "finishing_moves"
  s.version     = FinishingMoves::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frank Koehl", "Chris Tonkinson"]
  s.email       = ["frank@forgecrafted.com", "chris@forgecrafted.com"]
  s.summary     = %q{Small, focused, incredibly useful methods added to core Ruby classes.}
  s.description = <<-EOF
    Ruby includes a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself in a situation where an elaborate-yet-precise coding maneuver wins the day. Finishing Moves is a collection of methods designed to assist in those just-typical-enough-to-be-annoying scenarios.
  EOF
  s.homepage    = "https://github.com/forgecrafted/finishing_moves"
  s.license     = "MIT"

  s.files       = `git ls-files -z`.split("\x0")
  s.test_files  = Dir["spec/**/*"]

  s.add_development_dependency 'rb-readline', '>= 0'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'priscilla', '>= 0'
  s.add_development_dependency 'pry-byebug', '>= 0'
  s.add_development_dependency 'fuubar', '>= 0'

  s.required_ruby_version = '>= 1.9.3'

  s.post_install_message = <<EOS
********************************************************************************

  Thank you for installing Finishing Moves!

  Built and maintained by Forge Software
  www.forgecrafted.com

  Does your project or organization use this gem? Add it to the showcase page.
  https://github.com/forgecrafted/finishing_moves/wiki/showcase

********************************************************************************
EOS

end
