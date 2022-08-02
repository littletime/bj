require_relative "ia_player"
require_relative "dealer"
require_relative "deck"

class Table
  def initialize()
    @players = [IaPlayer.new]
    @deck = Deck.new(4, @players)
    @dealer = Dealer.new(@players, @deck)
  end

  attr_reader :dealer, :players, :deck

  def start_game()
    1000.times do
      play_turn
      #print_table
    end

    players[0].game_recap
  end

  def print_table
    print "DEALER CARDS : "
    dealer.hand.print_cards
    print "\n"
    players.each_with_index do |p, i|
      p.hands.each do |hand|
        print "PLAYER ##{i} CARDS : "
        hand.print_cards
        print " -- HAND VALUE : #{hand.value}"
        print "\n"
      end
    end
  end

  def play_turn
    deck.generate! if deck.passed_cut?
    clear_hands
    players.each &:place_bet
    dealer.initial_cards_deal
    players.each { |player| player_turn(player) }
    dealer.dealer_turn
    end_turn
  end

  def clear_hands
    dealer.hand.clear
    players.each &:clear_hands
  end

  def player_turn(player, splitted_hand = false)
    return player.end_turn! if !splitted_hand && black_jack?(player)

    while !player.hand.burnt? && (act = player.next_action) != Actions::STAY
      case act
      when Actions::HIT
        dealer.deal_card_to player
      when Actions::DOUBLE
        dealer.deal_card_to player
        break
      when Actions::SPLIT
        # play left game : deal new card and play
        dealer.deal_card_to player
        player_turn player, true
        # play right game : deal new card and play
        dealer.deal_card_to player
        player_turn player, true
        break
      end
    end

    player.end_turn!
  end

  def black_jack?(player)
    player.hand.black_jack? && !dealer.hand.black_jack?
  end

  def end_turn
    players.each do |player|
      player.hands.each do |player_hand|

        if player_hand.burnt?
          player.lose!
        elsif black_jack?(player)
          player.black_jack!
        elsif !dealer.hand.burnt?
          player.win! if player_hand.value > dealer.hand.value
          player.draw! if player_hand.value == dealer.hand.value
          player.lose! if player_hand.value < dealer.hand.value
        else
          player.win!
        end
      end
    end
  end
end
