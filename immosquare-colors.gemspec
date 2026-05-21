require_relative "lib/immosquare-colors/version"


Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.name          = "immosquare-colors"
  spec.version       = ImmosquareColors::VERSION.dup

  spec.authors       = ["immosquare"]
  spec.email         = ["jules@immosquare.com"]
  spec.homepage      = "https://github.com/immosquare/immosquare-colors"

  spec.summary       = "Ruby utility for complementary color derivation, tinting, shading and color conversions."
  spec.description   = "Provides methods to derive a black/white complementary color from luminance, tint or shade a color, convert HEX <-> RGBA, and resolve named colors to HEX."


  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency("immosquare-constants", "~> 0", ">= 0.1.3")

  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.6")
end
