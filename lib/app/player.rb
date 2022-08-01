require_relative "hand"

class Player
  def initialize(base_cash = 100)
    @cash = base_cash
    @hand = Hand.new
    @dealer_hand = []

    @wins = 0
    @draws = 0
    @losses = 0
  end

  attr_reader :hand

  def win!
    @cash += @bet * 2
    @wins += 1
  end

  def draw!
    @cash += @bet
    @draws += 1
  end

  def lose!
    @losses += 1
  end

  def double!
    @cash -= @bet
    @bet *= 2
  end

  def game_recap
    print "WINS: #{@wins} | DRAWS: #{@draws} | LOSSES: #{@losses} | FINAL_BALANCE: #{@cash}\n"
  end

  def place_bet
    @bet = 1
    @cash -= @bet
  end

  def next_action
    return Actions::HIT
  end

  def receive_card(card)
    hand.push card
  end

  def see_dealer_card(card)
    @dealer_hand.push card
  end

  def clear_hands()
    @hand = Hand.new
    @dealer_hand = []
  end
end