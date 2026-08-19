---
locale: en
tags:
  - app:immosquare-colors
  - audience:technique
---

# immosquare-colors

immosquare-colors is a Ruby utility for color conversions and derivations: HEX ↔ RGBA, complementary color (black/white) by luminance, tinting (toward white) and shading (toward black), and named-color → HEX lookup (backed by `immosquare-constants`). All methods are exposed as module-level singletons on `ImmosquareColors`.

This page covers installing the gem, the conversion and derivation methods it exposes, and how to run its test suite.

## Installing immosquare-colors

Add this line to your Gemfile:

```ruby
gem "immosquare-colors"
```

Then run:

```bash
bundle install
```

Or install immosquare-colors manually:

```bash
gem install immosquare-colors
```

## Converting colors with ImmosquareColors: HEX, RGBA and named colors

`ImmosquareColors.hex_to_rgba` converts a HEX string to an RGBA array.

```ruby
ImmosquareColors.hex_to_rgba("#FF5733")
# => [255, 87, 51]

ImmosquareColors.hex_to_rgba("#FF5733FF")
# => [255, 87, 51, 1.0]
```

`ImmosquareColors.rgba_to_hex` converts an RGBA array back to a HEX string. The alpha channel is appended only when present and different from `1.0`.

```ruby
ImmosquareColors.rgba_to_hex([255, 87, 51])
# => "#FF5733"

ImmosquareColors.rgba_to_hex([255, 87, 51, 1.0])
# => "#FF5733"

ImmosquareColors.rgba_to_hex([255, 87, 51, 0.5])
# => "#FF57337F"
```

`ImmosquareColors.color_name_to_hex` resolves a textual name to its HEX representation through `immosquare-constants`. Unknown names fall back to `"#000000"`.

```ruby
ImmosquareColors.color_name_to_hex("red")
# => "#ff0000"

ImmosquareColors.color_name_to_hex("fakecolor")
# => "#000000"
```

## Deriving colors with ImmosquareColors: complementary, tint and shade

The three derivation methods of `ImmosquareColors` — `get_complementary_color`, `tint_color` and `shade_color` — accept **either** a HEX string (`"#FF5733"` or `"#FF5733AA"` with alpha) **or** a named color (`"red"`, resolved via `immosquare-constants`).

`get_complementary_color` returns `"#000000"` or `"#FFFFFF"` — whichever provides the best contrast on the given color, based on luminance. Default luminance threshold is `127.5`.

```ruby
ImmosquareColors.get_complementary_color("#FF5733")
# => "#000000"

ImmosquareColors.get_complementary_color("#222222")
# => "#FFFFFF"

ImmosquareColors.get_complementary_color("red")
# => "#000000"
```

With a custom luminance threshold:

```ruby
ImmosquareColors.get_complementary_color("#6b89f8", :luminance => 200)
# => "#FFFFFF"
```

`tint_color` mixes the color with white. `weight` is a float between `0` (no tint) and `1` (pure white). The alpha channel, if any, is preserved.

```ruby
ImmosquareColors.tint_color("#FF5733", 0.5)
# => "#FFAB99"

ImmosquareColors.tint_color("#FF5733AA", 0.5)
# => "#FFAB99AA"
```

`shade_color` mixes the color with black. `weight` is a float between `0` (no shading) and `1` (pure black).

```ruby
ImmosquareColors.shade_color("#FF5733", 0.5)
# => "#802C1A"
```

## Developing and testing immosquare-colors

Install the dependencies, then run the immosquare-colors suite:

```bash
bundle install
bundle exec rspec
```

`bin/ci` is the entry point used by the Jenkins pipeline, and it runs the same way on a laptop — everything specific to the build agent is skipped when `JENKINS_WORKSPACE` is unset. It takes one of two subcommands:

| Command       | Effect                                                             |
| ------------- | ------------------------------------------------------------------ |
| `bin/ci init` | Installs the bundle without the `development` group                |
| `bin/ci test` | Runs `bundle exec rspec`                                           |

Coverage is off by default, so a local run stays fast and writes nothing. Set `COVERAGE=true` to enable it — `spec/coverage_helper.rb` then starts SimpleCov before the library is loaded and writes both an HTML report and `coverage/lcov.info`, which the pipeline publishes.

```bash
COVERAGE=true bundle exec rspec
```

## Contributing to immosquare-colors and license

Bug reports and pull requests are welcome on GitHub at [https://github.com/immosquare/immosquare-colors](https://github.com/immosquare/immosquare-colors). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
