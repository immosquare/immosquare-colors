require "immosquare-colors"

namespace :immosquare_colors do
  ##============================================================##
  ## bundle exec rake immosquare_extensions:get_complementary_color
  ##============================================================##
  task :get_complementary_color do
    colors = ["#6b89f8", "#222222", "red"]
    colors.each do |color|
      complementary = ImmosquareColors.get_complementary_color(color)
      puts "color: #{color} => complementary: #{complementary}"
    end
  end


  ##============================================================##
  ## tint color
  ##============================================================##
  task :tint_color do
    color = "#6b89f8"
    puts "color: #{color} => tinted: #{ImmosquareColors.tint_color(color, 80)}"
  end
end
