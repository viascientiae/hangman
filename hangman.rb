puts "Welcome to Hangman!"

# Check to ensure the dictionary file is available.
dictionary_available = (File.exist? "google-10000-english-no-swears.txt") ? "Yes" : "No"
puts "Is the dictionary available? : #{dictionary_available}"

# Loading the dictionary as an array
dictionary = File.readlines("google-10000-english-no-swears.txt")

# Creating a sub-set of words that are between 5 and 12 characters long from the dictionary
secret_words_list = dictionary.filter { |word| word.length >= 5 && word.length <= 12 }

# Randomly choosing a secret word that is between 5 and 12 characters long
secret_word = secret_words_list.sample
