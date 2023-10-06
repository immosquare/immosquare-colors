require_relative "lib/immosquare-colors/version"


Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.name          = "immosquare-colors"
  spec.version       = ImmosquareColors::VERSION.dup

  spec.authors       = ["IMMO SQUARE"]
  spec.email         = ["jules@immosquare.com"]
  spec.homepage      = "https://github.com/IMMOSQUARE/immosquare-colors"

  spec.summary       = "Ruby utility for complementary color derivation and color conversions."
  spec.description   = "Provides methods to suggest complementary colors based on luminance, convert HEX to RGBA, and map named colors to HEX"


  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency("immosquare-constants", "~> 0", ">= 0.1.1")

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.2")
end
