
class Game
  def initialize(odds_1,odds_2,odds_3,name_1,name_2,text_odds_1,text_odds_2,text_odds_3)
    @a_odds = odds_1
    @b_odds = odds_2
    @c_odds = odds_3
    @comp_1 = name_1
    @comp_2 = name_2
    @a_text_odds = text_odds_1
    @b_text_odds = text_odds_2
    @c_text_odds = text_odds_3
    @potential = 0
    @A = 100
  end
  
  def success?
    return @a_odds-((@b_odds+@c_odds+2)/(@b_odds*@c_odds-1))>0
  end
  
  def set_upper_bets
    @a_bet = @A
    @b_bet = (@a_bet*(@a_odds*@c_odds-1)/(@c_odds+1))
    @c_bet = (@a_odds*@a_bet - @b_bet)
  end
  
=begin
  def find_best_bets
    # first choose "a" as 100 because we need something to build on and we know it is >0.
    # then choose lowest "b" to compute c-bet interval.
    a_low_bet = @A
    b_low_bet = (a_low_bet*(@c_odds+1)/(@b_odds*@c_odds - 1))
    c_low_bet = ((a_low_bet+b_low_bet)/@c_odds)

    a_high_bet = @A
    b_high_bet = (a_low_bet*(@a_odds*@c_odds-1)/(@c_odds+1))
    c_high_bet = (@a_odds*a_low_bet - b_low_bet)

    #@a_bet = @A
    #@b_bet = (@a_bet*(@a_odds*@c_odds-1)/(@c_odds+1))
    #@c_bet = (@a_odds*@a_bet - @b_bet)

    
    b_best = 0
    c_best = 0
    best_bet = 0
    puts "b_low_bet " + b_low_bet.to_s
    puts "b_high_bet " + b_high_bet.to_s
    puts "c_low_bet " + c_low_bet.to_s
    puts "c_high_bet " + c_high_bet.to_s
    (b_low_bet..b_high_bet).step((b_high_bet-b_low_bet)/10) do |b_ex|
      (c_low_bet..c_high_bet).step((c_high_bet-c_low_bet)/10) do |c_ex|
        if a_low_bet*@a_odds + b_ex*@b_odds + c_ex*@c_odds - 2*(a_low_bet + b_ex + c_ex) > best_bet
          best_bet = a_low_bet*@a_odds + b_ex*@b_odds + c_ex*@c_odds - 2*(a_low_bet + b_ex + c_ex)
          b_best = b_ex
          c_best = c_ex
        end
      end
    end
    @a_bet = @A
    @b_bet = b_best
    @c_bet = c_best
    puts "Betting with optimal bets"
    self.bets_breakdown
  end  
  def set_middle_bets
    @a_bet = @A
    @b_bet = ((@a_bet*(@a_odds*@c_odds-1)/(@c_odds+1) + @a_bet*(@c_odds+1)/(@b_odds*@c_odds - 1)))/2
    @c_bet = ((@a_odds*@a_bet - @b_bet + (@a_bet+@b_bet)/@c_odds))/2
  end
  def set_lower_bets
    @a_bet = @A
    @b_bet = (@a_bet*(@c_odds+1)/(@b_odds*@c_odds - 1))
    @c_bet = ((@a_bet+@b_bet)/@c_odds)
  end
=end
  def set_potential
    # first part calculates %-chance of events occurring
    a_string = @a_text_odds.split("/")
    b_string = @b_text_odds.split("/")
    c_string = @c_text_odds.split("/")
    
    # dealing with single digit odds.
    if a_string[1] == nil
      a_string[1]="1"
    end
    if b_string[1] == nil
      b_string[1]="1"
    end
    if c_string[1] == nil
      c_string[1] = "1"
    end
    

      a_event_chance = a_string[1].to_f/(a_string[0].to_f + a_string[1].to_f)
      b_event_chance = b_string[1].to_f/(b_string[0].to_f + b_string[1].to_f)
      c_event_chance = c_string[1].to_f/(c_string[0].to_f + c_string[1].to_f)
    
    # calculate expectancy
    
    @potential = (@a_bet*@a_odds-(@b_bet+@c_bet))*a_event_chance + (@b_bet*@b_odds - (@a_bet+@c_bet))*b_event_chance + (@c_bet*@c_odds-(@a_bet + @b_bet))*c_event_chance
  end
  def get_potential
    return @potential
  end
  
  def bets_breakdown
    puts @comp_1.to_s + " vs. " + @comp_2.to_s
    puts "------------------------------"
    
    puts "Bets: "
    puts @a_bet
    puts @b_bet
    puts @c_bet
    puts @a_text_odds
    puts @b_text_odds
    puts @c_text_odds
    puts "Team " + @comp_1.to_s+" wins: Win " + (@a_bet*@a_odds).to_s + ", paid "+ (@b_bet+@c_bet).to_s
    puts "Draw: Win " + (@b_bet*@b_odds).to_s + ", paid "+ (@a_bet+@c_bet).to_s
    puts "Team " + @comp_2.to_s+" wins: Win " + (@c_bet*@c_odds).to_s + ", paid "+ (@a_bet+@b_bet).to_s
    puts "Potential:"
    puts @potential
    puts ""
  end
end
