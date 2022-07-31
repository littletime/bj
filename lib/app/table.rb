require_relative "ia_player"
require_relative "dealer"

class Table
  def initialize()
    @players = [IaPlayer.new()]
    @dealer = Dealer.new(@players)
  end

  attr_reader :dealer, :players

  def start_game()
    3.times do
      dealer.play_turn()
      print_table
    end
  end

  def print_table
    print "DEALER CARDS : "
    print_hand(dealer.hand)
    print "\n"
    players.each_with_index do |p, i|
      print "PLAYER ##{i} CARDS : "
      print_hand(p.hand)
      print "\n"
    end
  end

  def print_hand(hand)
    hand.each do |card|
      print card.value
      print " "
    end
  end
end
