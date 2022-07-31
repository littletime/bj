require_relative "actions"

class IaPlayer
  def initialize(base_cash = 100)
    @base_cash = base_cash
    @hand = []
    @dealer_hand = []
  end

  attr_reader :hand

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
    @hand = []
    @dealer_hand = []
  end

  def burnt?
    hand_value > 21
  end

  def hand_value
    total = 0
    sorted_hand = hand.sort { |a, b| b.value <=> a.value }
    
    hand.each do |card|
      if card.ace?
        if total + 11 > 21
          total += 1
        else
          total += 11
        end
      else
        total += card.value
      end
    end

    total
  end
end
