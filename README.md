---
locale: en
tags:
  - app:immosquare-colors
  - audience:technique
---

# immosquare-colors

immosquare-colors is a Ruby utility for color conversions and derivations: HEX ↔ RGBA, HEX ↔ HSL, complementary color (black/white) picked by WCAG contrast ratio, WCAG contrast measurement, mixing of two colors, tinting (toward white) and shading (toward black), opposite color on the wheel, and named-color → HEX lookup (backed by `immosquare-constants`). All methods are exposed as module-level singletons on `ImmosquareColors`.

This page covers installing the gem, the conversion, contrast and derivation methods it exposes, and how to run its test suite.

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

## Converting colors with ImmosquareColors: HEX, RGBA, HSL and named colors

`ImmosquareColors.hex_to_rgba` converts a HEX string to an RGBA array.

```ruby
ImmosquareColors.hex_to_rgba("#FF5733")
# => [255, 87, 51]

ImmosquareColors.hex_to_rgba("#FF5733FF")
# => [255, 87, 51, 1.0]
```

`ImmosquareColors.rgba_to_hex` converts an RGBA array back to a HEX string. The alpha channel is appended only when its 0–255 byte is below `255`. A missing alpha and an alpha of `1.0` both map to that byte, and so does a float just above `1.0` that still floors to `255`, so none of them gets a suffix.

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

`hex_to_hsl` returns `[hue, saturation, lightness]`, the hue in degrees between `0` and `360`, saturation and lightness between `0` and `1`.

```ruby
ImmosquareColors.hex_to_hsl("#FF5733")
# => [10.59, 1.0, 0.6]
```

`hsl_to_hex` converts such an array back to a HEX string. The hue wraps around, so a rotation past 360° needs no clamping by the caller.

```ruby
ImmosquareColors.hsl_to_hex([11.0, 1.0, 0.6])
# => "#FF5833"

ImmosquareColors.hsl_to_hex([400, 0.5, 0.5]) == ImmosquareColors.hsl_to_hex([40, 0.5, 0.5])
# => true
```

## Deriving colors with ImmosquareColors: complementary, tint, shade, mix and opposite

The derivation methods of `ImmosquareColors` — `get_complementary_color`, `tint_color`, `shade_color`, `mix_colors` and `get_opposite_color` — accept **either** a HEX string (`"#FF5733"` or `"#FF5733AA"` with alpha) **or** a named color (`"red"`, resolved via `immosquare-constants`).

`get_complementary_color` returns `"#000000"` or `"#FFFFFF"` — whichever of the two reads best on the given color, decided by WCAG contrast ratio.

```ruby
ImmosquareColors.get_complementary_color("#FF5733")
# => "#000000"

ImmosquareColors.get_complementary_color("#222222")
# => "#FFFFFF"

ImmosquareColors.get_complementary_color("red")
# => "#000000"
```

A perceived-brightness cutoff and the contrast ratio disagree around mid luminance: olives, mauves and muted greens sit just under a `127.5` brightness cutoff and are handed white, while black actually reads better on them. `#6c8539` scores 4.16:1 against white and 5.05:1 against black, so the contrast ratio picks black.

```ruby
ImmosquareColors.get_complementary_color("#6c8539")
# => "#000000"
```

Passing `:luminance` switches back to the former perceived-brightness cutoff, for callers that tuned their own threshold.

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

`mix_colors` mixes two colors in sRGB, `weight` being the share of the second one. It generalises `tint_color` (mixing with white) and `shade_color` (mixing with black), and mirrors what CSS `color-mix(in srgb, ...)` computes, so a value derived here matches what a browser renders. The alpha channel of the first color is carried over.

```ruby
ImmosquareColors.mix_colors("#FF5733", "#0000FF", 0.25)
# => "#BF4166"

ImmosquareColors.mix_colors("#FF5733AA", "#FFFFFF", 0.5)
# => "#FFAB99AA"
```

`get_opposite_color` returns the color sitting opposite on the color wheel — same saturation and lightness, hue rotated by 180°. It is useful to derive a secondary color that cannot be mistaken for a tint of the primary one, and it is its own inverse.

```ruby
ImmosquareColors.get_opposite_color("#523985")
# => "#6C8539"
```

## Measuring contrast with ImmosquareColors: WCAG ratio and accessibility levels

`contrast_ratio` returns the WCAG 2.1 contrast ratio between two colors, from `1` (identical colors) to `21` (black on white). The order of the arguments does not matter.

```ruby
ImmosquareColors.contrast_ratio("#6c8539", "#FFFFFF").round(2)
# => 4.16

ImmosquareColors.contrast_ratio("#6c8539", "#000000").round(2)
# => 5.05
```

`accessible_contrast?` answers whether two colors are far enough apart to be read together. `:level` selects the threshold:

| Level       | Ratio | Applies to                                          |
| ----------- | ----- | --------------------------------------------------- |
| `:aa`       | `4.5` | Body text — the default                             |
| `:aa_large` | `3.0` | Large text, and graphical objects such as icons     |
| `:aaa`      | `7.0` | Enhanced contrast                                   |

```ruby
ImmosquareColors.accessible_contrast?("#6c8539", "#FFFFFF")
# => false

ImmosquareColors.accessible_contrast?("#6c8539", "#FFFFFF", :level => :aa_large)
# => true
```

`relative_luminance` returns the WCAG 2.1 relative luminance of a color, between `0` (black) and `1` (white). Channels are linearised before being weighted, which is what separates it from a plain brightness average.

```ruby
ImmosquareColors.relative_luminance("#6c8539").round(4)
# => 0.2026
```

## Developing and testing immosquare-colors

Install the dependencies, then run the immosquare-colors suite:

```bash
bundle install
bundle exec rspec
```

`bin/ci` is the entry point used by the CI, and it runs the same way on a laptop — the runner selects the Ruby of `.ruby-version` and the gemset of `.ruby-gemset` before calling it, and the script provisions nothing itself. It takes one of three subcommands:

| Command       | Effect                                                             |
| ------------- | ------------------------------------------------------------------ |
| `bin/ci init` | Installs the bundle without the `development` group                |
| `bin/ci test` | Runs `bundle exec rspec` with coverage on                          |
| `bin/ci`      | Both, in that order (the default, `all`)                           |

Every subcommand exports `BUNDLE_WITHOUT=development`, so a gem the specs need belongs to the `test` group of the Gemfile. A plain `bundle exec rspec` leaves coverage off, so that local run stays fast and writes nothing. `bin/ci` defaults `COVERAGE` to `true` unless the variable is already set, and the CI collects `coverage/lcov.info`. `spec/coverage_helper.rb` starts SimpleCov before the library is loaded only when `COVERAGE` equals `true`, then writes both an HTML report and `coverage/lcov.info`.

```bash
COVERAGE=true bundle exec rspec
COVERAGE=false bin/ci test
```

## Contributing to immosquare-colors and license

Bug reports and pull requests are welcome on GitHub at [https://github.com/immosquare/immosquare-colors](https://github.com/immosquare/immosquare-colors). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
