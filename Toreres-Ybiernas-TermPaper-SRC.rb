#****************************************************************************************************************************************************************#
# A simple Lucky 9 game written in Ruby 3.1.3p185 in partial fulfillment of the requirement in CMSC 124 - Design and Implementation of Programming Language.     #
# Authors: Aldrich M. Toreres, Cloyd C. Ybiernas                                                                                                                 #
# Date: December 9, 2022                                                                                                                                         #
#****************************************************************************************************************************************************************#

# Simulate drawing of a single card from a deck.
def draw_card()
    # Draw 1 card from the deck
    card = rand(1..13)

    # If card is face card, value is 10
    if card > 10
        card = 10
    end
    return card
end

# Calculate the total score of the cards
def calculate_score(cards)
    score = 0

    # Loop through the cards, add each card's value to get score
    cards.each do |card|
        score += card
    end

    # Max score is 9
    while score > 9
        score -= 10
    end
    return score
end

# Show cards by looping and printing each card
def show_cards(cards)
    cards.each do |card|
        print " #{card} "
    end
end

# Returns the card and the hash with the new card
def draw_third_card(card, hash)
    # Makes sure that there are only 4 of each card number
    while(true)
        # Add card to hash if first time to be drawn, otherwise increment the number of times the card has been drawn
        if hash.include?(card)
            if hash[card] < 4
                hash[card]+=1
                return card, hash
            else
                # Draw another card since the current card has been drawn four times already
                card = draw_card(Show)
                next
            end
        else
            hash[card] = 1
            return card, hash
        end   
    end
end

# Main function of the program
def start_game()
    puts "============================================================="
    # Array that holds the cards of the player
    player_cards = []
    
    # Array the holds the cards of the dealer
    dealer_cards = []

    # Draw 2 cards from the deck for the player
    puts "Drawing cards..."
    2.times do
        player_cards << draw_card()
    end

    # Draw 2 cards from the deck for the dealer
    2.times do
        dealer_cards << draw_card()
    end

    # Array that holds the cards that have been drawn from the deck
    drawn_cards = player_cards + dealer_cards

    # Hash of drawn cards, key=card value, value=number of drawn card with same value
    hash_drawn_cards = drawn_cards.group_by(&:itself).transform_values!(&:size)

    # Show cards of player
    print "Player's hand: ["
    show_cards(player_cards)
    puts "]"
  
    # Player can decide to draw another card
    print "Would you like to draw another card? (y/n): "
    is_draw = gets.chomp()
  
    # Draw another card if player wants to
    if is_draw == 'y'
        puts "\nDrawing card..."
        
        result = draw_third_card(draw_card(), hash_drawn_cards)
        card = result[0]
        hash_drawn_cards = result[1]
        
        player_cards << card
        
        # Show cards of players after drawing another card
        print "Player's hand: ["
        show_cards(player_cards)
        puts "]"
    end

    # Calculate player's score
    player_score = calculate_score(player_cards)
    
    # Calculate dealer's score (before deciding wheter to draw another card or not)
    dealer_score = calculate_score(dealer_cards)

    # If dealer's score is less than 5, draw another card
    if dealer_score < 5
        puts "\nDealer wants to draw another card."
        puts "Drawing card..."
       
        result = draw_third_card(draw_card(), hash_drawn_cards)
        card = result[0]
        hash_drawn_cards = result[1]
       
        dealer_cards << card
        dealer_score = calculate_score(dealer_cards)
    else
        puts "\nDealer doesn't want to draw another card."
    end

    # Show dealer's hand
    print "Dealer's hand: ["
    show_cards(dealer_cards)
    puts "]"

    # Show player and dealer score
    puts "\nPlayer's score: #{player_score}" 
    puts "Dealer's score: #{dealer_score}"

    # Compare player's and dealer's score
    if dealer_score > player_score
        puts "\nYOU LOSE!"
    elsif dealer_score < player_score
        puts "\nYOU WIN!"
    else
        puts "\nA DRAW!"
    end
    puts "============================================================="
end

start_game()