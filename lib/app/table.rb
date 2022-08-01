require_relative "ia_player"
require_relative "dealer"

class Table
  def initialize()
    @players = [IaPlayer.new]
    @dealer = Dealer.new(@players)
  end

  attr_reader :dealer, :players

  def start_game()
    3000.times do
      dealer.play_turn
      print_table
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
end
