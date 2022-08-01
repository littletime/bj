require_relative "actions"
require_relative "player"
require_relative "basic_strategy"

class IaPlayer < Player
  def next_action
    action = basic_action hand.soft? ? BasicStrategy::SOFT : BasicStrategy::HARD

    double! if action == Actions::DOUBLE

    action
  end

  def basic_action(strategy)
    current_total = hand.value.to_s.to_sym
    dealer_card = @dealer_hand[0].value.to_s.to_sym

    strategy[current_total][dealer_card]
  end
end
