require "immosquare-constants"

module ImmosquareColors
  class << self

    ##============================================================##
    ## To determine whether the complementary color should be
    ## black or white.
    ##
    ## The answer is the overlay that actually reads best, decided by
    ## WCAG contrast ratio. A perceived-brightness cutoff does not
    ## agree with that ratio around mid luminance: olives, mauves and
    ## muted greens sit just under a 127.5 cutoff and are handed white,
    ## while black reads better on them. `#6c8539` for instance scores
    ## 4.16:1 against white and 5.05:1 against black.
    ##
    ## Passing `:luminance` keeps the former behaviour, for callers
    ## that tuned their own brightness cutoff.
    ##============================================================##
    def get_complementary_color(color, options = {})
      begin
        black     = "#000000"
        white     = "#FFFFFF"
        color_hex = color.start_with?("#") ? color : color_name_to_hex(color)

        raise("Not valid size") if ![7, 9].include?(color_hex.length)

        if options[:luminance]
          r, g, b = hex_to_rgba(color_hex)
          brightness = Math.sqrt((0.299 * (r**2)) + (0.587 * (g**2)) + (0.114 * (b**2)))
          return brightness > options[:luminance].to_f ? black : white
        end

        contrast_ratio(color_hex, white) >= contrast_ratio(color_hex, black) ? white : black
      rescue StandardError => e
        puts("=== Error! ===")
        puts(e.message)
        puts(e.backtrace)
        black
      end
    end

    ##============================================================##
    ## WCAG 2.1 contrast ratio between two colors, from 1 (identical)
    ## to 21 (black on white). Body text wants 4.5, large text and
    ## graphical objects 3.
    ##============================================================##
    def contrast_ratio(color_one, color_two)
      lighter, darker = [relative_luminance(color_one), relative_luminance(color_two)].minmax.reverse
      (lighter + 0.05) / (darker + 0.05)
    end

    ##============================================================##
    ## WCAG 2.1 relative luminance, between 0 (black) and 1 (white).
    ## Channels are linearised before being weighted, which is what
    ## separates it from a plain brightness average.
    ##============================================================##
    def relative_luminance(color)
      color_hex = color.start_with?("#") ? color : color_name_to_hex(color)
      channels  = hex_to_rgba(color_hex).first(3).map {|channel| channel / 255.0 }
      linear    = channels.map {|channel| channel <= 0.03928 ? channel / 12.92 : (((channel + 0.055) / 1.055)**2.4) }
      (0.2126 * linear[0]) + (0.7152 * linear[1]) + (0.0722 * linear[2])
    end

    ##============================================================##
    ## To transform a hex color to rgba
    ##============================================================##
    def hex_to_rgba(hex_color)
      hex_color   = hex_color.gsub("#", "")
      red         = hex_color[0..1].to_i(16)
      green       = hex_color[2..3].to_i(16)
      blue        = hex_color[4..5].to_i(16)
      rgba        = [red, green, blue]
      rgba += [(hex_color[6..7].to_i(16) / 255.0).round(2)] if hex_color.length == 8
      rgba
    end

    ##============================================================##
    ## To transform a rgba color (array) to hex
    ##============================================================##
    def rgba_to_hex(rgba_color)
      r, g, b, a = rgba_color
      hex_string = format("#%02x%02x%02x", r, g, b)
      hex_string += format("%02x", (a * 255).floor) if a && a != 1.0
      hex_string.upcase
    end

    ##============================================================##
    ## A dictionary for mapping textual colors to colors
    ## hex
    ##============================================================##
    def color_name_to_hex(color_name)
      ImmosquareConstants::Color.color_name_to_hex(color_name.downcase.to_sym) || "#000000"
    end

    ##============================================================##
    ## Mix color whith white (255, 255, 255)
    ##============================================================##
    def tint_color(color, weight)
      color_hex   = color.start_with?("#") ? color : color_name_to_hex(color)
      r, g, b, a  = hex_to_rgba(color_hex)
      tinted_r    = (((1 - weight) * r) + (weight * 255)).round
      tinted_g    = (((1 - weight) * g) + (weight * 255)).round
      tinted_b    = (((1 - weight) * b) + (weight * 255)).round
      rgba_to_hex([tinted_r, tinted_g, tinted_b, a])
    end

    ##============================================================##
    ## Mix color whith black (0, 0, 0)
    ##============================================================##
    def shade_color(color, weight)
      color_hex   = color.start_with?("#") ? color : color_name_to_hex(color)
      r, g, b, a  = hex_to_rgba(color_hex)
      shaded_r    = (r * (1 - weight)).round
      shaded_g    = (g * (1 - weight)).round
      shaded_b    = (b * (1 - weight)).round
      rgba_to_hex([shaded_r, shaded_g, shaded_b, a])
    end

    ##============================================================##
    ## Mix two colors in sRGB, `weight` being the share of the second
    ## one. Generalises tint (mix with white) and shade (mix with
    ## black), and mirrors what CSS `color-mix(in srgb, ...)` computes,
    ## so a value derived here matches what a browser would render.
    ## Alpha is carried over from the first color.
    ##============================================================##
    def mix_colors(color_one, color_two, weight)
      one_hex        = color_one.start_with?("#") ? color_one : color_name_to_hex(color_one)
      two_hex        = color_two.start_with?("#") ? color_two : color_name_to_hex(color_two)
      r1, g1, b1, a1 = hex_to_rgba(one_hex)
      r2, g2, b2     = hex_to_rgba(two_hex)
      mixed          = [[r1, r2], [g1, g2], [b1, b2]].map {|from, to| (((1 - weight) * from) + (weight * to)).round }
      rgba_to_hex(mixed + [a1].compact)
    end

    ##============================================================##
    ## The color sitting opposite on the color wheel: same saturation
    ## and lightness, hue rotated by 180°. Useful to derive a secondary
    ## color that cannot be mistaken for a tint of the primary one.
    ##============================================================##
    def get_opposite_color(color)
      h, s, l = hex_to_hsl(color)
      hsl_to_hex([h + 180, s, l])
    end

    ##============================================================##
    ## Whether two colors are far enough apart to be read together.
    ## `:level` accepts :aa (4.5, body text), :aa_large (3, large text
    ## and graphical objects such as icons or logos) and :aaa (7).
    ##============================================================##
    def accessible_contrast?(color_one, color_two, options = {})
      thresholds = {:aa => 4.5, :aa_large => 3.0, :aaa => 7.0}
      threshold  = thresholds[(options[:level] || :aa).to_sym] || thresholds[:aa]
      contrast_ratio(color_one, color_two) >= threshold
    end

    ##============================================================##
    ## To transform a hex color to HSL, hue in degrees (0...360),
    ## saturation and lightness between 0 and 1.
    ##============================================================##
    def hex_to_hsl(color)
      color_hex   = color.start_with?("#") ? color : color_name_to_hex(color)
      r, g, b     = hex_to_rgba(color_hex).first(3).map {|channel| channel / 255.0 }
      high, low   = [r, g, b].minmax.reverse
      lightness   = (high + low) / 2.0
      return [0.0, 0.0, lightness.round(4)] if high == low

      delta      = high - low
      saturation = lightness > 0.5 ? delta / (2.0 - high - low) : delta / (high + low)
      hue        = case high
                   when r then ((g - b) / delta) + (g < b ? 6.0 : 0.0)
                   when g then ((b - r) / delta) + 2.0
                   else        ((r - g) / delta) + 4.0
                   end
      [(hue * 60.0).round(2), saturation.round(4), lightness.round(4)]
    end

    ##============================================================##
    ## To transform an HSL array back to hex. The hue wraps around, so
    ## a rotation past 360° needs no clamping by the caller.
    ##============================================================##
    def hsl_to_hex(hsl)
      hue, saturation, lightness = hsl
      hue = (hue % 360) / 360.0
      return rgba_to_hex([(lightness * 255).round] * 3) if saturation == 0

      second = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - (lightness * saturation)
      first  = (2 * lightness) - second
      rgba_to_hex([1.0 / 3, 0, -1.0 / 3].map {|offset| (hue_to_channel(first, second, hue + offset) * 255).round })
    end


    private

    ##============================================================##
    ## One channel of an HSL → RGB conversion, from the two
    ## intermediate values and the hue shifted for that channel.
    ##============================================================##
    def hue_to_channel(first, second, hue)
      hue += 1 if hue < 0
      hue -= 1 if hue > 1
      return first + ((second - first) * 6 * hue)       if hue < 1.0 / 6
      return second                                     if hue < 1.0 / 2
      return first + ((second - first) * ((2.0 / 3) - hue) * 6) if hue < 2.0 / 3

      first
    end

  end
end
