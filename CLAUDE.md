# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

immosquare-colors is a Ruby gem providing color utility methods: complementary color derivation based on luminance, HEX/RGBA conversions, color tinting/shading, and named color to HEX mapping.

## Commands

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rspec

# Run a single test file
bundle exec rspec spec/immosquare-colors_spec.rb

# Run rake tasks for manual testing
bundle exec rake immosquare_colors:get_complementary_color
bundle exec rake immosquare_colors:tint_color
```

## Architecture

Single-module gem with all functionality in `ImmosquareColors` class methods:

- `lib/immosquare-colors.rb` - Main module with all color methods
- `lib/immosquare-colors/version.rb` - Version constant

Dependencies:
- `immosquare-constants` - Provides `ImmosquareConstants::Color.color_name_to_hex` for named color lookup

## Key Methods

| Method | Purpose |
|--------|---------|
| `get_complementary_color(color, options)` | Returns black or white based on luminance calculation |
| `hex_to_rgba(hex_color)` | Converts 6 or 8 character HEX to RGBA array |
| `rgba_to_hex(rgba_color)` | Converts RGBA array to HEX string |
| `color_name_to_hex(color_name)` | Maps color names (e.g., "red") to HEX |
| `tint_color(color, weight)` | Lightens color by blending with white |
| `shade_color(color, weight)` | Darkens color by blending with black |

All methods accept both HEX strings (`#FF5733`) and named colors (`red`).
