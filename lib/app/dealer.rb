require_relative "deck"
require_relative "actions"
require_relative "hand"

class Dealer
  def initialize(players)
    @deck = Deck.new(6)
    @players = players
    @hand = Hand.new
  end

  attr_reader :players, :deck, :hand

  def play_turn()
    prepare_cards

    players.each &:place_bet

    initial_deal
    players.each { |player| player_turn(player) }
    dealer_turn

    players.each do |player|
      player.hands.each do |player_hand|
        return player.win! if !player_hand.burnt? && (hand.burnt? || (!player_hand.burnt? && player_hand.value > hand.value))
        return player.draw! if hand.value == player_hand.value
        player.lose!
      end
    end
  end

  def prepare_cards
    hand.clear
    players.each &:clear_hands
    if deck.passed_cut?
      deck.generate!
    end
  end

  def player_turn(player)
    while !player.hand.burnt? && (act = player.next_action) != Actions::STAY
      case act
      when Actions::HIT
        deal_card_to player
      when Actions::DOUBLE
        deal_card_to player
        break
      when Actions::SPLIT
        # play left game : deal new card and play
        deal_card_to player
        player_turn player

        # play right game : deal new card and play
        deal_card_to player
        player_turn player

        break
      end
    end

    player.end_turn!
  end

  def initial_deal
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