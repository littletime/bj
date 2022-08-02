require_relative "hand"

class Player
  def initialize(base_cash = 200)
    @cash = base_cash

    @wins = 0
    @black_jacks = 0
    @draws = 0
    @losses = 0

    @last_games = []

    clear_hands
  end

  attr_reader :hand, :hands

  def win!
    print "WIN\n"
    @cash += @bet * 2
    @wins += 1
    @last_games.push :win
  end

  def black_jack!
    print "BLACK JACK 💸\n"
    @cash += @bet * 2.5
    @black_jacks += 1
    @last_games.push :black_jack
  end

  def draw!
    print "DRAW\n"
    @cash += @bet
    @draws += 1
    @last_games.push :draw
  end

  def lose!
    print "LOSS\n"
    @losses += 1
    @last_games.push :loss
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
    print "\n--------\nBLACK JACKS: #{@black_jacks} | WINS: #{@wins} | DRAWS: #{@draws} | LOSSES: #{@losses} | FINAL_BALANCE: #{@cash}\n--------\n"
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

  def new_deck!(decks_nb)
    # do nothing here
  end
end