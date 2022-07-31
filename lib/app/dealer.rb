require_relative "deck"
require_relative "actions"

class Dealer
  def initialize(players)
    @deck = Deck.new()
    @players = players
  end

  attr_reader :players, :deck, :hand

  def play_turn()
    @hand = []
    players.each &:clear_hands
    deal

    players.each { |player| player_turn(player) }
  end

  def player_turn(player)
    while (act = player.next_action) != Actions::STAY && !player.burnt?
      case act
      when Actions::HIT
        deal_card_to player
      end
    end
  end

  def deal()
    deal_one_card_to_all_players
    draw_visible_dealer_card
    deal_one_card_to_all_players
    draw_hidden_dealer_card
  end

  def draw_visible_dealer_card()
    hand.push deck.draw
    players.each { |p| p.see_dealer_card(hand.first) }
  end

  def draw_hidden_dealer_card()
    hand.push deck.draw
  end

  def deal_one_card_to_all_players()
    players.each do |p|
      deal_card_to p
    end
  end

  def deal_card_to(player)
    player.receive_card deck.draw
  end
end