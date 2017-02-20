require "nokogiri"
require 'json'
require 'pry'
require 'csv'
require './game.rb'
require 'httparty'

public
def to_float
  string = self.split("/")
  return string[0].to_f/string[1].to_f
end

# requesting the page
page = HTTParty.get('http://www.oddschecker.com/football')

# making the http response into a nokogiri object
parse_page = Nokogiri::HTML(page)

# writing parsed html to file for future reference
#File.open("html", 'w'){|file| file.write(parse_page)}

# array of odds and names and checks
names_array = []
odds_array = []
text_odds_array = []

# making the odds array from the html 
parse_page.css(".match-on").css(".odds").map do |a|
  # text odds will be needed to compute expectancies later on
  text_odds = a.text.gsub(/[()]/, "").strip
  # clean numeric odds will be needed for normal computations
  clean_odds = text_odds.to_float
  # push each into the respective array
  text_odds_array.push(text_odds)
  odds_array.push(clean_odds)
end

# making the competitors array from the html
parse_page.css(".match-on").css(".fixtures-bet-name").map do |a|
  title = a.text
  names_array.push(title)
end

# The interesting bit, it loops through every third element and does the calculation
# RELIES HEAVILY ON THE FACT THAT TEAM ARRAY MATCHES ODDS ARRAY!!
(0..odds_array.length-1).step(3) do |i|
  current_game = Game.new(odds_array[i],odds_array[i+1],odds_array[i+2],names_array[i],names_array[i+2],text_odds_array[i],text_odds_array[i+1],text_odds_array[i+2])
  if current_game.success?
    puts names_array[i] + " vs. " + names_array[i+2]
    puts "------------------------------"
    current_game.set_upper_bets
  end
end

# writing to file

#File.open("div", "w") {|file| file.write(odds_array)}
#CSV.open("odds.csv", "w") do |csv| csv << odds_array end





