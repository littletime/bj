require_relative "actions"
require_relative "player"
require_relative "basic_strategy"
require_relative "count_values"

class IaPlayer < Player
  def initialize
    super
    @current_count = 0
  end

  def next_action
    #print "CURRENT COUNT : #{@current_count}\n"
    if hand.pair? && basic_action(BasicStrategy::PAIRS) == true
      split!
      return Actions::SPLIT
    end

    action = basic_action hand.soft? ? BasicStrategy::SOFT : BasicStrategy::HARD

    double! if action == Actions::DOUBLE

    action
  end

  def basic_action(strategy)
    current_total = hand.value.to_s.to_sym
    dealer_card = @dealer_hand[0].value.to_s.to_sym

    strategy[current_total][dealer_card]
  end

  def new_card!(card, remaining_decks)
    @current_count += card_value(card)
    @remaining_decks = remaining_decks
  end

  def new_deck!(decks_nb)
    print "\nRESET COUNT\n"
    @remaining_decks = decks_nb
    @current_count = 0
  end

  def card_value(card)
    Count::VALUES.each do |key, val|
      if val.include? card.value
        return key.to_s.to_i
      end
    end
  end

  def true_count
    return 1 if @current_count <= 0 || @current_count < @remaining_decks

    @current_count / @remaining_decks
  end

  def streak?(result, games_nb = 2)
    true_count > 0 && @last_games.last(games_nb).all? { |res| res == result }
  end

  def place_bet
    super soft_spread
    #super risky_spread
  end

  def soft_spread(base_bet = 2)
    return base_bet * 2 if true_count == 2
    return base_bet * 4 if true_count == 3
    return base_bet * 8 if true_count >= 4
    base_bet
  end

  def risky_spread(base_bet = 2)
    streak_coeff = if streak?(:win)
      3
    elsif streak?(:loss, 5)
      6
    else
      1
    end

    risk_coeff = if @cash < 800
      true_count
    elsif @cash < 1000
      true_count * 2
    else
      true_count * true_count
    end

    print "BASE BET : #{base_bet} | RISK_COEFF : #{risk_coeff} | STREAK COEFF : #{streak_coeff} | TRUE COUNT : #{true_count}\n"
    base_bet * risk_coeff * streak_coeff
  end
end
