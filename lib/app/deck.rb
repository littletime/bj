require_relative "card"

class Deck
  def initialize(decks_nb = 1)
    @cards = []

    load_cards(decks_nb)
    shuffle
  end

  attr_reader :cards

  def load_cards(decks_nb)
    decks_nb.times do
      Card::CARDS.each do |val|
        @cards.push Card.new(val)
      end      
    end
  end

  def shuffle()
    @cards.shuffle!
  end

  def draw()
    return cards.shift
  end
end