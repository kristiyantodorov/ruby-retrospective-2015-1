module Rules
        def get_rank
                all_ranks = {jack: 11, queen: 12, king: 13, ace: 14}

                case rank
                        when 2..10
                                rank
                        else
                                all_ranks[rank]
                        end
        end

        def get_suit
                all_suits = {spades: 4, hearts: 3, diamonds: 2, clubs: 1}
                all_suits[suit]
        end
end

module CardGenerator
        module_function
        @all_ranks = {jack: 11, queen: 12, king: 13, ace: 14}

        def generate(first = 2)
                clubs(first) + diamonds(first) + hearts(first) + spades(first)
        end

        def clubs(first)
                all_clubs = (first..10).to_a
                @all_ranks.keys.each { |rank| all_clubs << rank.to_sym}
                generated_clubs = []
                all_clubs.each {|club| generated_clubs << Card.new(club, :clubs)}
                generated_clubs
        end

        def diamonds(first)
                all_diamonds = (first..10).to_a
                @all_ranks.keys.each { |rank| all_diamonds << rank.to_sym.to_sym}
                generated_diamonds = []
                all_diamonds.each {|club| generated_diamonds << Card.new(club, :diamonds)}
                generated_diamonds
        end

        def hearts(first)
                all_hearts = (first..10).to_a
                @all_ranks.keys.each { |rank| all_hearts << rank.to_sym}
                generated_hearts = []
                all_hearts.each {|club| generated_hearts << Card.new(club, :hearts)}
                generated_hearts
        end

        def spades(first)
                all_spades = (first..10).to_a
                @all_ranks.keys.each { |rank| all_spades << rank.to_sym}
                generated_spades = []
                all_spades.each {|club| generated_spades << Card.new(club, :spades)}
                generated_spades
        end
end

class Card
        include Rules

        @suit
        @rank

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

        def ==(other_card)
                rank == other_card.rank and suit == other_card.suit
        end

        def to_s
                case rank
                        when 2..10
                                "#{@rank} of #{@suit.capitalize}"
                        else
                                "#{@rank.capitalize} of #{@suit.capitalize}"
                        end
        end
end

class Deck
        include Enumerable
        include CardGenerator

        @deck

        def initialize(starting_deck = [])
                if starting_deck.empty?
                        @deck = CardGenerator.generate
                else
                        @deck = starting_deck
                end
        end

        def deck
                @deck
        end

        def size
                @deck.length
        end

        def deal(number_of_cards)
                hand = []
                shuffle
                while number_of_cards > 0 and deck.size > 0
                        number_of_cards -= 1
                        hand << draw_top_card
                end
                Deck.new(hand)
        end

        def draw_top_card
                @deck.delete_at(0)
        end

        def draw_bottom_card
                @deck.delete_at(-1)
        end

        def top_card
                @deck[0]
        end

        def bottom_card
                @deck[-1]
        end

        def shuffle
                @deck.shuffle!
        end

        def sort
                @deck.sort! { |x, y| y.get_rank <=> x.get_rank }
                @deck.sort! { |x, y| y.get_suit <=> x.get_suit }
        end

        def to_s
                puts @deck
        end

        def each
                current = 0
                while current < deck.length
                        yield deck[current]
                        current += 1
                end
        end
end

class WarDeck < Deck
        @war_deck

        def initialize(starting_deck = Deck.new)
                @war_deck = starting_deck
        end

        def get_deck
                @war_deck.deck
        end

        def to_s
                puts @war_deck.deck
        end

        def deal
                WarDeck.new(@war_deck.deal(26))
        end

        def play_card
                get_deck.delete_at(0)
        end

        def allow_face_up?
                get_deck.length <= 3
        end
end