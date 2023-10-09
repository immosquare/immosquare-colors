require "immosquare-constants"

module ImmosquareColors
  class << self

    ##============================================================##
    ## To determine whether the complementary color should be
    ## black or white
    ##============================================================##
    def get_complementary_color(color, options = {})
      begin
        luminance_std = (options[:luminance] || 127.5).to_f
        black         = "#000000"
        white         = "#FFFFFF"
        color_hex     = color.start_with?("#") ? color : color_name_to_hex(color)

        raise("Not valid size") if ![7, 9].include?(color_hex.length)


        color_rgba = hex_to_rgba(color_hex)
        r, g, b, a = color_rgba

        ##============================================================##
        ## luminance calculation
        ##============================================================##
        luminance = Math.sqrt((0.299 * (r**2)) + (0.587 * (g**2)) + (0.114 * (b**2)))
        luminance > luminance_std ? black : white
      rescue StandardError => e
        puts("=== Error! ===")
        puts(e.message)
        puts(e.backtrace)
        black
      end
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

  end
end
