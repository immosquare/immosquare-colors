require_relative "lib/immosquare-colors/version"


Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.name          = "immosquare-colors"
  spec.version       = ImmosquareColors::VERSION.dup

  spec.authors       = ["immosquare"]
  spec.email         = ["jules@immosquare.com"]
  spec.homepage      = "https://github.com/immosquare/immosquare-colors"

  spec.summary       = "Ruby utility for color conversions, WCAG contrast and color derivation."
  spec.description   = "Converts HEX, RGBA, HSL and named colors, measures WCAG contrast, mixes two colors in sRGB, and derives a black or white complementary color from the contrast ratio, plus tint, shade and the opposite hue."


  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency("immosquare-constants", "~> 0", ">= 0.1.3")

  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.6")
end
