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
    if hand.pair? && basic_action(BasicStrategy::PAIRS) == true
      split!
      print "\nSPLIT\n"
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
    print "CURRENT COUNT : #{@current_count}\n"
  end

  def card_value(card)
    Count::VALUES.each do |key, val|
      if val.include? card.value
        return key.to_s.to_i
      end
    end
  end

  def place_bet
    super(@current_count < 1 ? 1 : (@current_count / @remaining_decks))
  end
end
