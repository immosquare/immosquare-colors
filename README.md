# immosquare Colors

Enhance your Ruby experience with utility methods for standard classes like `String`, `Array`, and `Hash`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'immosquare-colors'
```

Then execute:

```bash
$ bundle install
```

Or install it yourself:

```bash
$ gem install immosquare-colors
```

## Usage

### Getting the Complementary Color (standard luminance value is 127.5):

The `get_complementary_color` method helps determine if the complementary color of a given color should be black or white.

```ruby
color         = "#FF5733"
complementary = ImmosquareColors.get_complementary_color(color)
puts complementary  # This will output "#000000" (black) based on default luminance calculation.
```

With custom luminance:

```ruby
complementary = ImmosquareColors.get_complementary_color(color, luminance: 150.0)
puts complementary  # The output might vary based on the custom luminance.
```

### Convert HEX to RGBA:

If you have a HEX color and need its RGBA representation, the `hex_to_rgba` method is what you need.

```ruby
hex_color = "#FF5733FF"
rgba      = ImmosquareColors.hex_to_rgba(hex_color)
puts rgba  # This outputs an array: [255, 87, 51, 1.0]
```

### Convert RGBA to HEX:

To convert an RGBA array representation back to its HEX representation, use the `rgba_to_hex` method.

```ruby
rgba_array = [255, 87, 51, 1.0]
hex_color  = ImmosquareColors.rgba_to_hex(rgba_array)
puts hex_color  # This outputs: "#FF5733FF"
```

### Tinting Colors:

To lighten a color by blending it with white, use the `tint` method.

```ruby
color     = "#FF5733"
tinted    = ImmosquareColors.tint(color, 0.5)
puts tinted  # This outputs: "#FFAB99"
```

### Shading Colors:

To darken a color by blending it with black, use the `shade` method.

```ruby
color     = "#FF5733"
shaded    = ImmosquareColors.shade(color, 0.5)
puts shaded  # This outputs : #7F2B19
```

### Named Color to HEX:

Map textual color names to their HEX representation using the `color_name_to_hex` method.

```ruby
color_name          = "red"
hex_representation  = ImmosquareColors.color_name_to_hex(color_name)
puts hex_representation  # This outputs "#FF0000"
```


## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/IMMOSQUARE/immosquare-colors](https://github.com/IMMOSQUARE/immosquare-colors). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
