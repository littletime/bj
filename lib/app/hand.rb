class Hand
  def initialize(cards = [])
    @cards = cards
  end

  def push(card)
    @cards.push card
  end

  def clear
    @cards = []
  end

  def first
    cards[0]
  end

  def soft?
    cards.any? { |card| card.ace? } && value(true) <= 11
  end

  def burnt?
    value > 21
  end

  def pair?
    cards.count == 2 && cards[0].value == cards[1].value
  end

  def value(hard = false)
    total = 0
    sorted_hand = cards.sort { |a, b| b.value <=> a.value }

    sorted_hand.each do |card|
      if card.ace? && !hard
        if total + 11 <= 21
          total += 11
        else
          total += 1
        end
      else
        total += card.value
      end
    end

    total
  end

  def print_cards
    cards.each do |card|
      print card.value
      print " "
    end
  end

  def black_jack?
    hand_values = @cards.map &:value

    hand_values.count == 2 && hand_values.include?(1) && hand_values.include?(10)
  end

  private

  attr_reader :cards
end