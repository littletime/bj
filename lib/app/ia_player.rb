class IaPlayer
  def initialize(base_cash = 100)
    @base_cash = base_cash
    @hand = []
    @dealer_hand = []
  end

  attr_reader :hand

  def receive_card(card)
    hand.push card
  end

  def see_dealer_card(card)
    @dealer_hand.push card
  end
end