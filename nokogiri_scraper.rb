require "nokogiri"
require 'json'
require 'pry'
require 'csv'
require './game.rb'
require 'httparty'

public
def to_float
  string = self.split("/")
  #some odds are represented as a single digit and not a fraction
  if string[1] != nil
    return string[0].to_f/string[1].to_f
  else
    return string[0].to_f
  end
end

# requesting the page
page = HTTParty.get('http://odds.bestbetting.com/football/england/premier-league/')

# making the http response into a nokogiri object
parse_page = Nokogiri::HTML(page)

# array of odds and names and checks
teams_array = []
odds_array = []
text_odds_array = []
games_array = []

# making the odds array from the html 
parse_page.css(".row0, .row1").css(".selectionBestOdd").map do |a|
  # text odds will be needed to compute expectancies later on
  text_odds = a.text.gsub(/[()]/, "").strip
  # clean numeric odds will be needed for normal computations
  clean_odds = text_odds.to_float
  # push each into the respective array
  text_odds_array.push(text_odds)
  odds_array.push(clean_odds)
end


# making the competitors array from the html
parse_page.css(".row0, .row1").css(".firstColumn").css("a").map do |a|
  title = a.text.split(" v ")
  teams_array.push(title[0]).push("draw").push(title[1])
end

# The interesting bit, it loops through every third element and does the calculation
# RELIES HEAVILY ON THE FACT THAT TEAM ARRAY MATCHES ODDS ARRAY!!

(0..odds_array.length-1).step(3) do |i|
  current_game = Game.new(odds_array[i],odds_array[i+1],odds_array[i+2],teams_array[i],teams_array[i+2],text_odds_array[i],text_odds_array[i+1],text_odds_array[i+2])
  if current_game.success?
    current_game.set_upper_bets
    current_game.set_potential
    games_array.push(current_game)
    puts "hej"
  end
end
puts games_array

if games_array.length >0
  #sorting array
  games_array.sort_by! { |a|
    a.get_potential
  }
  
  games_array.each do |a|
    puts a.bets_breakdown
  end
end

#File.open("div", "w") {|file| file.write(odds_array)}
#CSV.open("odds.csv", "w") do |csv| csv << odds_array end





