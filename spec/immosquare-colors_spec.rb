require "spec_helper"
require "immosquare-colors"

##============================================================##
## bundle exec rspec spec/immosquare-colors_spec.rb
##============================================================##
RSpec.describe(ImmosquareColors) do
  describe(".get_complementary_color") do
    it("returns black for a bright color") do
      expect(described_class.get_complementary_color("#6b89f8")).to(eq("#000000"))
    end

    it("returns white for a dark color") do
      expect(described_class.get_complementary_color("#222222")).to(eq("#FFFFFF"))
    end

    it("respects custom luminance values") do
      expect(described_class.get_complementary_color("#6b89f8", :luminance => 200)).to(eq("#FFFFFF"))
    end

    it("handles named colors") do
      expect(described_class.get_complementary_color("red")).to(eq("#000000"))
    end

    ##============================================================##
    ## Mid-luminance colors are where a brightness cutoff and the WCAG
    ## ratio disagree: both of these sit just under the former 127.5
    ## threshold and used to be handed white, which reads worse.
    ##============================================================##
    it("prefers black on mid-luminance colors where it reads better") do
      expect(described_class.get_complementary_color("#6c8539")).to(eq("#000000"))
      expect(described_class.get_complementary_color("#ba6aa9")).to(eq("#000000"))
    end

    it("always returns the overlay with the higher contrast ratio") do
      ["#6c8539", "#ba6aa9", "#826aed", "#f9b41f", "#222222", "#ffffff"].each do |color|
        chosen = described_class.get_complementary_color(color)
        other  = chosen == "#FFFFFF" ? "#000000" : "#FFFFFF"
        expect(described_class.contrast_ratio(color, chosen)).to(be >= described_class.contrast_ratio(color, other))
      end
    end
  end

  describe(".relative_luminance") do
    it("returns 0 for black and 1 for white") do
      expect(described_class.relative_luminance("#000000")).to(eq(0.0))
      expect(described_class.relative_luminance("#ffffff")).to(eq(1.0))
    end
  end

  describe(".contrast_ratio") do
    it("returns 21 for black on white and 1 for a color on itself") do
      expect(described_class.contrast_ratio("#000000", "#ffffff").round(2)).to(eq(21.0))
      expect(described_class.contrast_ratio("#523985", "#523985").round(2)).to(eq(1.0))
    end

    it("does not depend on the order of its arguments") do
      expect(described_class.contrast_ratio("#523985", "#ffffff")).to(eq(described_class.contrast_ratio("#ffffff", "#523985")))
    end
  end

  describe(".accessible_contrast?") do
    it("applies the threshold of the requested level") do
      expect(described_class.accessible_contrast?("#6c8539", "#ffffff")).to(be(false))
      expect(described_class.accessible_contrast?("#6c8539", "#ffffff", :level => :aa_large)).to(be(true))
      expect(described_class.accessible_contrast?("#6c8539", "#000000")).to(be(true))
      expect(described_class.accessible_contrast?("#6c8539", "#000000", :level => :aaa)).to(be(false))
    end
  end

  describe(".hex_to_hsl and .hsl_to_hex") do
    it("round-trips a color through HSL") do
      ["#523985", "#F9B41F", "#0C632E", "#FFFFFF", "#000000", "#808080"].each do |color|
        expect(described_class.hsl_to_hex(described_class.hex_to_hsl(color))).to(eq(color))
      end
    end

    it("wraps a hue past 360 degrees") do
      expect(described_class.hsl_to_hex([400, 0.5, 0.5])).to(eq(described_class.hsl_to_hex([40, 0.5, 0.5])))
    end
  end

  describe(".get_opposite_color") do
    it("rotates the hue by half the wheel") do
      expect(described_class.get_opposite_color("#523985")).to(eq("#6C8539"))
      expect(described_class.get_opposite_color("#B42B55")).to(eq("#2BB48A"))
    end

    it("is its own inverse") do
      expect(described_class.get_opposite_color(described_class.get_opposite_color("#523985"))).to(eq("#523985"))
    end
  end

  describe(".mix_colors") do
    it("matches tint when mixed with white and shade when mixed with black") do
      expect(described_class.mix_colors("#523985", "#FFFFFF", 0.3)).to(eq(described_class.tint_color("#523985", 0.3)))
      expect(described_class.mix_colors("#523985", "#000000", 0.3)).to(eq(described_class.shade_color("#523985", 0.3)))
    end

    it("returns either end of the range at weight 0 and 1") do
      expect(described_class.mix_colors("#523985", "#F9B41F", 0)).to(eq("#523985"))
      expect(described_class.mix_colors("#523985", "#F9B41F", 1)).to(eq("#F9B41F"))
    end

    it("keeps the alpha of the first color") do
      expect(described_class.mix_colors("#FF5733AA", "#FFFFFF", 0.5)).to(eq("#FFAB99AA"))
    end
  end

  describe(".hex_to_rgba") do
    it("converts hex to rgba") do
      expect(described_class.hex_to_rgba("#FF5733")).to(eq([255, 87, 51]))
    end

    it("converts 8-character hex to rgba") do
      expect(described_class.hex_to_rgba("#FF5733FF")).to(eq([255, 87, 51, 1.0]))
    end
  end

  describe(".rgba_to_hex") do
    it("converts rgba to hex") do
      expect(described_class.rgba_to_hex([255, 87, 51])).to(eq("#FF5733"))
    end

    it("converts rgba with full opacity to 8-character hex") do
      expect(described_class.rgba_to_hex([255, 87, 51, 1.0])).to(eq("#FF5733"))
    end

    it("converts rgba with partial opacity to 8-character hex") do
      expect(described_class.rgba_to_hex([255, 87, 51, 0.5])).to(eq("#FF57337F"))
    end
  end

  describe(".color_name_to_hex") do
    it("converts color name to hex") do
      expect(described_class.color_name_to_hex("red")).to(eq("#ff0000"))
    end

    it("returns black for unknown colors") do
      expect(described_class.color_name_to_hex("fakecolor")).to(eq("#000000"))
    end
  end

  describe(".tint_color") do
    context("with hex colors") do
      it("returns a tinted color based on the given weight") do
        expect(described_class.tint_color("#FF5733", 0.5)).to(eq("#FFAB99"))
      end

      it("returns the same color when weight is 0%") do
        expect(described_class.tint_color("#FF5733", 0)).to(eq("#FF5733"))
      end

      it("returns white when weight is 100%") do
        expect(described_class.tint_color("#FF5733", 1)).to(eq("#FFFFFF"))
      end
    end

    context("with RGBA colors") do
      it("keeps the alpha component intact") do
        expect(described_class.tint_color("#FF5733AA", 0.5)).to(eq("#FFAB99AA"))
      end
    end
  end

  describe(".shade") do
    it("returns a shaded color based on the given weight") do
      expect(described_class.shade_color("#FF5733", 0.5)).to(eq("#802C1A"))
    end
  end
end
