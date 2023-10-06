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
    ## A dictionary for mapping textual colors to colors
    ## hex
    ##============================================================##
    def color_name_to_hex(color_name)
      ImmosquareConstant::Color.color_name_to_hex[color_name.downcase.to_sym] || "#000000"
    end

  end
end
