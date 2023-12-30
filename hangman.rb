require 'yaml'

# # Check to ensure the dictionary file is available
# dictionary_available = (File.exist? "google-10000-english-no-swears.txt") ? "Yes" : "No"
# puts "Is the dictionary available? : #{dictionary_available}"

class Computer
  attr_reader :secret_word

  def initialize
    @secret_word = select_secret_code
  end

  def select_secret_code
    dictionary = File.readlines("google-10000-english-no-swears.txt").map { |word| word.chomp }.filter { |word| word.length >= 5 && word.length <= 12 }

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
    @turn = 1
    @incorrect_guesses = 0
    @secret_word_display = "_" * @secret_word.length
  end

  def play

    secret_word_length = @secret_word.length

    @secret_word_display = @secret_word_display

    incorrect_guesses_allowed = 6
    secret_word_array = @secret_word.split("")

    puts "\n-------------------------------------------------------------------------------"
    puts "Let's begin the game. You're allowed only #{incorrect_guesses_allowed - @incorrect_guesses} incorrect guesses."
    puts "-------------------------------------------------------------------------------\n"
    while @incorrect_guesses <= incorrect_guesses_allowed do
      puts "\nTurn ##{@turn}"
      puts "-------------------------------------------------------------------------------"
      puts "\nSecret Word: #{@secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - @incorrect_guesses})"
      print "\nTo continue the game enter 1 or to save the game enter 2: "
      choice = gets.chomp
      if choice == "1"
        print "\n#{@player_name}, please guess a letter of the secret word or the whole secret word itself: "
        player_guess = gets.downcase.chomp
        if player_guess.length == 1
          if secret_word_array.any?(player_guess)
            secret_word_array.each_with_index do |letter, index|
              if letter == player_guess
                @secret_word_display[index] = player_guess
              end
            end
            if @secret_word_display == secret_word_array
              puts "\nSecret Word: #{@secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - @incorrect_guesses})"
              puts "\nCongratulations #{@player_name}! You've won the game! You've correctly guessed the secret word."
              puts "-------------------------------------------------------------------------------\n\n"
              break
            end
          else
            @incorrect_guesses += 1
          end
        elsif player_guess.length > 1
          if player_guess == secret_word_array
            @secret_word_display = player_guess
            puts "\nSecret Word: #{@secret_word_display}\n\n(Secret Word Length: #{secret_word_length})\n(Number of incorrect guesses remaining: #{incorrect_guesses_allowed - @incorrect_guesses})"
            puts "\nCongratulations #{@player_name}! You've won the game! You've correctly guessed the secret word."
            puts "-------------------------------------------------------------------------------\n\n"
            break
          else
            @incorrect_guesses += 1
          end
        end

        if @incorrect_guesses == 6
          puts "\nYou've lost #{@player_name}.\n\nYou've run out of allowed number of incorrect guesses.\n\nThe secret word was #{secret_word}"
          puts "-------------------------------------------------------------------------------\n\n"
          break
        end

        puts "-------------------------------------------------------------------------------\n\n"

        @turn += 1

      elsif choice == "2"
        print "\nPlease enter a filename for saving the game without the file extension: "
        filename = gets.chomp + ".yml"
        File.open(filename, 'w') { |file| file.write(YAML::dump(self))}
        puts "\nThe game has been saved."
        break
      end
    end
  end
end

def load_game
  print "\nWelcome to Hangman!\n\nWould you like to play a new game or load a saved game?\n\nEnter yes for a new game and no for loading a saved game (yes/no) "
  choice = gets.chomp
  if choice == "no"
    print "\nEnter the filename of the saved game you want to load without the file extension: "
    filename = gets.chomp + ".yml"
    if File.exist?(filename) && !File.zero?(filename)
      print "\nA saved game was found by that filename. Do you want to resume? (yes/no): "
      answer = gets.chomp.downcase
      if answer == "yes"
        return YAML.safe_load(File.read(filename), permitted_classes: [Game, Player, Computer])
      end
    end
  else
    create_new_game
  end
end

def create_new_game
  player_name = prompt_player_name
  computer = Computer.new
  player = Player.new(player_name)
  Game.new(player_name, computer)
end

def prompt_player_name
  print "\nPlease enter your name to start a new game: "
  gets.chomp
end

game = load_game
game.play
