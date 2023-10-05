require "spec_helper"
require "immosquare-colors"

##============================================================##
## bundle exec rspec spec/immosquare-colors_spec.rb
##============================================================##
RSpec.describe(ImmosquareColors) do
  describe ".get_complementary_color" do
    it "returns black for a bright color" do
      expect(described_class.get_complementary_color("#6b89f8")).to(eq("#000000"))
    end

    it "returns white for a dark color" do
      expect(described_class.get_complementary_color("#222222")).to(eq("#FFFFFF"))
    end

    it "respects custom luminance values" do
      expect(described_class.get_complementary_color("#6b89f8", :luminance => 200)).to(eq("#FFFFFF"))
    end

    it "handles named colors" do
      expect(described_class.get_complementary_color("red")).to(eq("#000000"))
    end
  end

  describe ".hex_to_rgba" do
    it "converts hex to rgba" do
      expect(described_class.hex_to_rgba("#FF5733")).to(eq([255, 87, 51]))
    end

    it "converts 8-character hex to rgba" do
      expect(described_class.hex_to_rgba("#FF5733FF")).to(eq([255, 87, 51, 1.0]))
    end
  end

  describe ".color_name_to_hex" do
    it "converts color name to hex" do
      expect(described_class.color_name_to_hex("red")).to(eq("#ff0000"))
    end

    it "returns black for unknown colors" do
      expect(described_class.color_name_to_hex("fakecolor")).to(eq("#000000"))
    end
  end
end
