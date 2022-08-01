require_relative "actions"
require_relative "hand"

class Dealer
  def initialize(players, deck)
    @players = players
    @deck = deck
    @hand = Hand.new
  end

  attr_reader :players, :deck, :hand

  def initial_cards_deal
    deal_one_card_to_all_players
    draw_visible_dealer_card
    deal_one_card_to_all_players
    draw_hidden_dealer_card
  end

  def dealer_turn
    while hand.value < 17
      hand.push deck.draw
    end
  end

  def draw_visible_dealer_card
    hand.push deck.draw
    players.each { |p| p.see_dealer_card(hand.first) }
  end

  def draw_hidden_dealer_card
    hand.push deck.draw
  end

  def deal_one_card_to_all_players
    players.each do |p|
      deal_card_to p
    end
  end

  def deal_card_to(player)
    player.receive_card deck.draw
  end
end