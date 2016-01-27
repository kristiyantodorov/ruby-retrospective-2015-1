class Card
  include Comparable
  attr_accessor :suit, :rank

  SUITS = [:clubs, :diamonds, :hearts, :spades].freeze
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace].freeze

  def initialize(card_rank, card_suit)
    @suit = card_suit
    @rank = card_rank
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def <=>(other)
    compare = SUITS.find_index(suit) <=> SUITS.find_index(other.suit)
    if compare == 0
      compare = RANKS.find_index(rank) <=> RANKS.find_index(other.rank)
    end
    compare
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.to_s.capitalize}"
  end
end

module DeckMethods
  include Enumerable

  def each(&block)
    current_deck.each(&block)
  end

  def size
    current_deck.size
  end

  def draw_top_card
    current_deck.shift
  end

  def draw_bottom_card
    current_deck.pop
  end

  def top_card
    current_deck.first
  end

  def bottom_card
    current_deck.last
  end

  def shuffle
    current_deck.shuffle!
  end

  def sort
    current_deck.sort!.reverse!
  end

  def to_s
    current_deck.map(&:to_s).join("\n")
  end
end

class Deck
  include DeckMethods

  def initialize(starting_deck = [])
    if starting_deck.empty?
      @deck = self.class.deck_generator
    else
      @deck = starting_deck
    end
  end

  def self.deck_generator
    Card::RANKS.product(Card::SUITS).each_with_object([]) do |pair, deck|
      deck << Card.new(pair.first, pair.last)
    end
  end

  def current_deck
    @deck
  end
end

class WarDeck < Deck
  HAND_SIZE = 26

  def deal
    hand = []
    HAND_SIZE.times { hand << draw_top_card }
    WarHand.new(hand)
  end
end

class WarHand
  include DeckMethods

  def initialize(hand)
    @hand = hand
  end

  alias_method :play_card, :draw_top_card

  def allow_face_up?
    @hand.length <= 3
  end

  def current_deck
    @hand
  end
end

class SixtySixDeck < Deck
  RANKS = [9, 10, :jack, :queen, :king, :ace].freeze
  HAND_SIZE = 6

  def initialize(deck = [])
    if deck == []
      @deck = self.class.generate_deck
    else
      @deck = deck
    end
  end

  def deal
    hand = []
    HAND_SIZE.times { hand << draw_top_card }
    SixtySixHand.new(hand)
  end

  def self.generate_deck
    RANKS.product(Card::SUITS).each_with_object([]) do |pair, deck|
      deck << Card.new(pair.first, pair.last)
    end
  end
end

class SixtySixHand
  include DeckMethods

  def initialize(hand)
    @hand = hand
  end

  def twenty?(trump_suit)
    game_suits = Card::SUITS.dup
    game_suits.delete(trump_suit)
    game_suits.any? do |suit|
      @hand.include? Card.new(:queen, suit) and
        @hand.include? Card.new(:king, suit)
    end
  end

  def forty?(trump_suit)
    @hand.include? Card.new(:queen, trump_suit) and
      @hand.include? Card.new(:king, trump_suit)
  end

  def current_deck
    @hand
  end
end

class BeloteDeck < Deck
  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace].freeze
  HAND_SIZE = 8
  attr_reader :deck

  def initialize(deck = [])
    if deck == []
      @deck = self.class.generate_deck
    else
      @deck = deck
    end
  end

  def deal
    hand = []
    HAND_SIZE.times { hand << draw_top_card }
    BeloteHand.new(hand)
  end

  def self.generate_deck
    RANKS.product(Card::SUITS).each_with_object([]) do |pair, deck|
      deck << Card.new(pair.first, pair.last)
    end
  end
end

class BeloteHand
  include DeckMethods

  def initialize(hand)
    @hand = hand
  end

  def highest_of_suit(suit)
    matching_suit = @hand.select { |card| card.suit == suit }
    BeloteHand.new(matching_suit).sort.first
  end

  def belote?
    Card::SUITS.any? do |suit|
      @hand.include? Card.new(:queen, suit) and
        @hand.include? Card.new(:king, suit)
    end
  end

  def cards_by_suit(suit)
    @hand.select { |card| card.suit == suit }
  end

  def ranks_by_suit(suit)
    cards_by_suit(suit).map { |card| card.rank }
  end

  def carre_of_jacks?
    @hand.select { |card| card.rank == :jack }.size == 4
  end

  def carre_of_nines?
    @hand.select { |card| card.rank == 9 }.size == 4
  end

  def carre_of_aces?
    @hand.select { |card| card.rank == :ace }.size == 4
  end

  def same_suit_consecutive(number)
    check_each_suit
  end

  def sequence?(number)
    Card::SUITS.any? do |suit|
      ranks = ranks_by_suit(suit)
      BeloteDeck::RANKS.each_cons(number).any? do |consecutive_ranks|
        (consecutive_ranks & ranks).size == number
      end
    end
  end

  def tierce?
    sequence? 3
  end

  def quarte?
    sequence? 4
  end

  def quint?
    sequence? 5
  end

  def current_deck
    @hand
  end
end
