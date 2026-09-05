## [0.1.6] - 2026-09-04

### Added
- WCAG 2.1 contrast surface: `contrast_ratio`, `relative_luminance` and `accessible_contrast?` (levels `:aa`, `:aa_large`, `:aaa`)
- `mix_colors`, which mixes two colors in sRGB and mirrors CSS `color-mix(in srgb, ...)`
- `get_opposite_color`, the color opposite on the wheel (hue rotated by 180°)
- HSL conversions: `hex_to_hsl` and `hsl_to_hex`

### Changed
- `get_complementary_color` now picks black or white by WCAG contrast ratio instead of a perceived-brightness cutoff; passing `:luminance` keeps the former behaviour
- Minimum required Ruby version raised to 3.2.6

## [0.1.5] - 2023-10-08
- tint_color & shade_color value in %

## [0.1.4] - 2023-10-08
- Add new functions : rgba_to_hex, tint_color, shade_color

## [0.1.3] - 2023-10-06
- Fixbug with immosquare-constants

## [0.1.2] - 2023-10-06
- Move COLORS to immosquare-constants

## [0.1.1] - 2023-10-05
- Initial release
