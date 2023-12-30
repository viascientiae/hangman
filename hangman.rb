puts "Welcome to Hangman!"

# # Check to ensure the dictionary file is available
# dictionary_available = (File.exist? "google-10000-english-no-swears.txt") ? "Yes" : "No"
# puts "Is the dictionary available? : #{dictionary_available}"

# Load the dictionary as an array of words that are 5-12 characters in length and with the newline character at their ends removed
dictionary = File.readlines("google-10000-english-no-swears.txt").map { |word| word.chomp }.filter { |word| word.length >= 5 && word.length <= 12 }

# Randomly choose a secret word from the dictionary as loaded above
secret_word = dictionary.sample

# # Display the secret word for testing purposes
# puts "Secret Word: #{secret_word}"

# Variable to store length of the secret word
secret_word_length = secret_word.length

# Initialize variable as an empty array. The array will display the secret word's length and correct letter guesses
secret_word_display = []

# Initialize a counter variable
i = 0
# Loop to create the array that will display the secret word's length and correct letter guesses
while i < secret_word_length do
  secret_word_display.push("_")
  i += 1
end
secret_word_display = secret_word_display.join

# Variable initiliazed with initial value to track the number of turns of the game
turn = 1
# Variable initialized to store the number of incorrect guesses made by the player
incorrect_guesses = 0
# Variable initialized to store the number of incorrect guesses allowed at the start of the game
incorrect_guesses_allowed = 6
# Array initialized to store the letters of the secret word
secret_word_array = secret_word.split("")

# Message to display when beginning the game
puts "\n-------------------------------------------------------------------------------"
puts "Let's begin the game. You're allowed only #{incorrect_guesses_allowed} incorrect guesses."
puts "-------------------------------------------------------------------------------\n"
# Main game logic loop
while incorrect_guesses <= incorrect_guesses_allowed do
  puts "\nTurn ##{turn}"
  puts "-------------------------------------------------------------------------------"
  puts "\nSecret Word: #{secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - incorrect_guesses})"
  print "\nPlease guess a letter of the secret word or the whole secret word itself: "
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
        puts "\nCongratulations! You've won the game! You've correctly guessed the secret word."
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
      puts "\nCongratulations! You've won the game! You've correctly guessed the secret word."
      puts "-------------------------------------------------------------------------------\n\n"
      break
    else
      incorrect_guesses += 1
    end
  end

  if incorrect_guesses == 6
    puts "\nYou lost! You've run out of allowed number of incorrect guesses.\n\nThe secret word was #{secret_word}"
    puts "-------------------------------------------------------------------------------\n\n"
    break
  end

  puts "-------------------------------------------------------------------------------\n\n"

  turn += 1
end
