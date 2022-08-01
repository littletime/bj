require_relative "hand"

class Player
  def initialize(base_cash = 100)
    @cash = base_cash

    @wins = 0
    @draws = 0
    @losses = 0

    clear_hands
  end

  attr_reader :hand, :hands

  def win!
    print "WIN\n"
    @cash += @bet * 2
    @wins += 1
  end

  def draw!
    print "DRAW\n"
    @cash += @bet
    @draws += 1
  end

  def lose!
    print "LOSS\n"
    @losses += 1
  end

  def double!
    @cash -= @bet
    @bet *= 2
  end

  def split!
    @hands.push Hand.new([@hand.first])
    @hand = @hands[@current_hand] = Hand.new([@hand.first])
    @cash -= @bet
  end

  def end_turn!
    # if we have more hands to play
    if @current_hand + 1 < @hands.count
      @current_hand += 1
      set_hand
    end
  end

  def game_recap
    print "\n--------\nWINS: #{@wins} | DRAWS: #{@draws} | LOSSES: #{@losses} | FINAL_BALANCE: #{@cash}\n--------\n"
  end

  def place_bet(val = 1)
    @bet = val
    @cash -= @bet

    print "PLACING BET : #{@bet} -- "
    print "REMAINING CASH : #{@cash}\n"
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
    @hands = [Hand.new]
    @current_hand = 0
    @dealer_hand = []

    set_hand
  end

  def set_hand
    @hand = @hands[@current_hand]
  end

  def new_card!(card, remaining_decks)
    # do nothing here
  end
end