# # Check to ensure the dictionary file is available
# dictionary_available = (File.exist? "google-10000-english-no-swears.txt") ? "Yes" : "No"
# puts "Is the dictionary available? : #{dictionary_available}"

class Computer
  attr_reader :secret_word

  def initialize
    @secret_word = select_secret_code
  end

  def select_secret_code
    # Load the dictionary as an array of words that are 5-12 characters in length and with the newline character at their ends removed
    dictionary = File.readlines("google-10000-english-no-swears.txt").map { |word| word.chomp }.filter { |word| word.length >= 5 && word.length <= 12 }

    # Randomly choose a secret word from the dictionary as loaded above
    dictionary.sample
  end
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end
end


class Game
  attr_reader :player_name, :secret_word

  def initialize(player_name, computer)
    @player_name = player_name.to_s
    @secret_word = computer.secret_word
  end

  def play
    # # Display the secret word for testing purposes
    # puts "Secret Word: #{@secret_word}"

    secret_word_length = @secret_word.length
    secret_word_display = []

    i = 0
    while i < secret_word_length do
    secret_word_display.push("_")
    i += 1
    end

    secret_word_display = secret_word_display.join

    turn = 1
    incorrect_guesses = 0
    incorrect_guesses_allowed = 6
    secret_word_array = @secret_word.split("")

    puts "\n-------------------------------------------------------------------------------"
    puts "Let's begin the game. You're allowed only #{incorrect_guesses_allowed} incorrect guesses."
    puts "-------------------------------------------------------------------------------\n"
    # Main game logic loop
    while incorrect_guesses <= incorrect_guesses_allowed do
      puts "\nTurn ##{turn}"
      puts "-------------------------------------------------------------------------------"
      puts "\nSecret Word: #{secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - incorrect_guesses})"
      print "\n#{@player_name}, please guess a letter of the secret word or the whole secret word itself: "
      player_guess = gets.downcase.chomp

      if player_guess.length == 1
        if secret_word_array.any?(player_guess)
          secret_word_array.each_with_index do |letter, index|
            if letter == player_guess
              secret_word_display[index] = player_guess
            end
          end
          if secret_word_display == secret_word_array.join
            puts "\nSecret Word: #{secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - incorrect_guesses})"
            puts "\nCongratulations #{@player_name}! You've won the game! You've correctly guessed the secret word."
            puts "-------------------------------------------------------------------------------\n\n"
            break
          end
        else
          incorrect_guesses += 1
        end
      elsif player_guess.length > 1
        if player_guess == secret_word_array.join
          secret_word_display = player_guess
          puts "\nSecret Word: #{secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - incorrect_guesses})"
          puts "\nCongratulations #{@player_name}! You've won the game! You've correctly guessed the secret word."
          puts "-------------------------------------------------------------------------------\n\n"
          break
        else
          incorrect_guesses += 1
        end
      end

      if incorrect_guesses == 6
        puts "\nYou've lost #{@player_name}.\n\nYou've run out of allowed number of incorrect guesses.\n\nThe secret word was #{secret_word}"
        puts "-------------------------------------------------------------------------------\n\n"
        break
      end

      puts "-------------------------------------------------------------------------------\n\n"

      turn += 1
    end
    end
  end

puts "Welcome to Hangman!"
print "\nPlease enter your name to start the game: "
player_name = gets.chomp
computer = Computer.new
player = Player.new(player_name)
game = Game.new(player_name, computer)
game.play
