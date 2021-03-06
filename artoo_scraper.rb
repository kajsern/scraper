require './game.rb'
require 'csv'


public
def to_float
  string = self.first.split("/")
  #some odds are represented as a single digit and not a fraction
  if string[1] != nil
    return string[0].to_f/string[1].to_f
  else
    return string[0].to_f
  end
end


teams_array = []
text_odds_array = []
odds_array = []
games_array = []

text_odds_array = CSV.read("./data.csv").drop(1)
text_odds_array.each do |a|
  odds_array.push(a.to_float)
end

teams = CSV.read("./teams.csv")
teams.drop(1).each do |a|
  splitting = a.first.split(" - ")
  teams_array.push(splitting[0],"draw", splitting[1])
end


# The interesting bit, it loops through every third element and does the calculation
# RELIES HEAVILY ON THE FACT THAT TEAM ARRAY MATCHES ODDS ARRAY!!

(0..odds_array.length-1).step(3) do |i|
  current_game = Game.new(odds_array[i],odds_array[i+1],odds_array[i+2],teams_array[i],teams_array[i+2],text_odds_array[i],text_odds_array[i+1],text_odds_array[i+2])
  if current_game.success?
    current_game.set_upper_bets
    current_game.set_potential
    games_array.push(current_game)
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
