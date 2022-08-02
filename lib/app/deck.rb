require_relative "card"

class Deck
  def initialize(decks_nb = 1, players)
    @decks_nb = decks_nb
    @players = players
    @cards = []
    generate!
  end

  def generate!
    @cards = []

    load_cards(@decks_nb)
    shuffle
    @cut = rand(0..(@cards.count * 0.75))
    # @cut = @cards.count / 2
    @players.each { |p| p.new_deck!(@decks_nb) }
  end

  def remaining_decks
    @decks_nb - (@cards.count / 52)
  end

  def draw
    card = cards.shift
    players.each { |p| p.new_card! card, remaining_decks }
    card
  end

  def passed_cut?
    @cards.count + @cut <  @decks_nb * 52
  end

  private

  attr_reader :cards, :players

  def load_cards(decks_nb)
    decks_nb.times do
      Card::CARDS.each do |val|
        @cards.push Card.new(val)
      end      
    end
  end

  def shuffle
    @cards.shuffle!
  end
end