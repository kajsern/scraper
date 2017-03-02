require './game.rb'
require 'csv'

teams_array =[]

data_array = CSV.read("./data.csv").drop(1)

teams = CSV.read("./teams.csv")
teams.drop(1).each do |a|
  splitting = a.first.split(" - ")
  teams_array.push(splitting[0],"draw", splitting[1])
end

