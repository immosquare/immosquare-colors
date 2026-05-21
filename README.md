# immosquare-colors

Ruby utility for color conversions and derivations: HEX ↔ RGBA, complementary color (black/white) by luminance, tinting (toward white) and shading (toward black), and named-color → HEX lookup (backed by `immosquare-constants`).

## Installation

Add this line to your Gemfile:

```ruby
gem "immosquare-colors"
```

Then run:

```bash
bundle install
```

Or install it manually:

```bash
gem install immosquare-colors
```

## Usage

All methods are exposed as module-level singletons on `ImmosquareColors`.

Methods that accept a `color` argument (`get_complementary_color`, `tint_color`, `shade_color`) accept **either** a HEX string (`"#FF5733"` or `"#FF5733AA"` with alpha) **or** a named color (`"red"`, resolved via `immosquare-constants`).

### Complementary color (black or white)

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

### Convert HEX to RGBA

```ruby
ImmosquareColors.hex_to_rgba("#FF5733")
# => [255, 87, 51]

ImmosquareColors.hex_to_rgba("#FF5733FF")
# => [255, 87, 51, 1.0]
```

### Convert RGBA to HEX

The alpha channel is appended only when present and different from `1.0`.

```ruby
ImmosquareColors.rgba_to_hex([255, 87, 51])
# => "#FF5733"

ImmosquareColors.rgba_to_hex([255, 87, 51, 1.0])
# => "#FF5733"

ImmosquareColors.rgba_to_hex([255, 87, 51, 0.5])
# => "#FF57337F"
```

### Tint a color (toward white)

`tint_color` mixes the color with white. `weight` is a float between `0` (no tint) and `1` (pure white). The alpha channel, if any, is preserved.

```ruby
ImmosquareColors.tint_color("#FF5733", 0.5)
# => "#FFAB99"

ImmosquareColors.tint_color("#FF5733AA", 0.5)
# => "#FFAB99AA"
```

### Shade a color (toward black)

`shade_color` mixes the color with black. `weight` is a float between `0` (no shading) and `1` (pure black).

```ruby
ImmosquareColors.shade_color("#FF5733", 0.5)
# => "#802C1A"
```

### Named color to HEX

Resolves a textual name to its HEX representation through `immosquare-constants`. Unknown names fall back to `"#000000"`.

```ruby
ImmosquareColors.color_name_to_hex("red")
# => "#ff0000"

ImmosquareColors.color_name_to_hex("fakecolor")
# => "#000000"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/immosquare/immosquare-colors](https://github.com/immosquare/immosquare-colors). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
