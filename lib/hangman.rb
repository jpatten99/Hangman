#have fun :)
class Hangman
  require 'yaml'
  attr_reader :blank_str, :word_arr

  @@game_number = rand(0..10000)

  def initialize
    @correct_letters = []
    @incorrect_letters = []
    @guesses_remaining = 15
    @continue_game = true
    @word_arr = choose_word
    @blank_str = @word_arr.map { '-' }.join('')
    @input_added = false
    @file_loaded = false
    
  end

  def choose_word
    lines = File.readlines('google-10000-english-no-swears.txt')
    word_chosen = false
    until word_chosen
      random_number = rand(0..9893)
      lines.each_with_index do |word, index|
        if index == random_number
          word = word.gsub("\n", '')
          if word.length > 4 && word.length < 13
            word_chosen = true
            # p word
            # return word
            return word.split('')
          end
        end
      end
    end
  end

  def already_guessed?(letter, corr_array, incor_array)
    corr_array.each do |corr_letter|
      if corr_letter == letter
        true
      end
    end
    incor_array.each do |incor_letter|
      if incor_letter == letter
        true
      end
    end
    false
  end

  def guess_letter(input_letter, input_array)
    input_letter = input_letter.downcase
    output_arr = []
    @input_added = false
    input_array.each_with_index do |arr_letter, index| 
      if input_letter == arr_letter
        output_arr.push(index)
        unless @input_added
          @correct_letters.push(input_letter)
        end
        @input_added = true
      end
    end
    output_arr.each do |index|
      @blank_str[index] = input_letter
    end
    if output_arr.length.zero?
      @incorrect_letters.push(input_letter)
    end
  end

  def save_game
    save_data = [@correct_letters, @incorrect_letters, @guesses_remaining, @continue_game, @word_arr.join(''), @blank_str]
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/game_#{@@game_number}.yaml"
    File.open(filename, 'w') do |file|
      file.write(save_data.to_yaml)
    end
  end

  def load_game(load_file)
    loaded_data = YAML.load(File.read("#{load_file}"))
    @correct_letters = loaded_data[0]
    @incorrect_letters = loaded_data[1]
    @guesses_remaining = loaded_data[2]
    @continue_game = loaded_data[3]
    @word_arr = loaded_data[4].split('')
    @blank_str = loaded_data[5]
    p @word_arr
  end

  def play_game
    while true
      puts 'Welcome to hangman, would you like to (1) Start new game or (2) Load saved game?'
      new_or_continue = gets.chomp
      if new_or_continue == '1' || new_or_continue == '2'
        break
      end
    end
    case new_or_continue
    when '1'
      while @continue_game
        if @blank_str.split('') == @word_arr
          puts "You figured the word out! It is '#{word_arr.join('')}'"
          return
        end
        if @guesses_remaining.zero?
          puts "Correct letters guessed: #{@correct_letters.join(' ')}"
          puts "Incorrect letters guessed: #{@incorrect_letters.join(' ')}"
          puts "The word was #{word_arr.join('')}"
          break
        end
  
        puts "You have #{@guesses_remaining} guesses left, enter next guess!"
        puts "Correct letters guessed: #{@correct_letters.join(' ')}"
        puts "Incorrect letters guessed: #{@incorrect_letters.join(' ')}"
        puts @blank_str
        guess = gets.chomp
        if guess.downcase == 'save'
          save_game
          @continue_game = false
          next
        end
        while guess.length != 1 && guess.downcase != 'save' 
          puts 'Incorrect format, only enter a single letter!'
          guess = gets.chomp
        end
        guess_letter(guess, word_arr)
        @guesses_remaining -= 1
        
      end
    when '2'
      while !@file_loaded
        puts "Please enter a file from the output directory, if that is empty you have no saved games! EX: output/game_10.yaml"
        load_file = gets.chomp
        if File.exist?(load_file)
          load_game(load_file)
          @file_loaded = true
        end
      end
      while @continue_game
        if @blank_str.split('') == @word_arr
          puts "You figured the word out! It is '#{word_arr.join('')}'"
          return
        end
        if @guesses_remaining.zero?
          puts "Correct letters guessed: #{@correct_letters.join(' ')}"
          puts "Incorrect letters guessed: #{@incorrect_letters.join(' ')}"
          puts "The word was #{word_arr.join('')}"
          break
        end
        puts "You have #{@guesses_remaining} guesses left, enter next guess!"
        puts "Correct letters guessed: #{@correct_letters.join(' ')}"
        puts "Incorrect letters guessed: #{@incorrect_letters.join(' ')}"
        puts @blank_str
        guess = gets.chomp
        if guess.downcase == 'save'
          save_game
          @continue_game = false
          next
        end
        while guess.length != 1 && guess.downcase != 'save' 
          puts 'Incorrect format, only enter a single letter!'
          guess = gets.chomp
        end
        guess_letter(guess, word_arr)
        @guesses_remaining -= 1
      end
    end
  end
end

hangman = Hangman.new
hangman.play_game




###################
=begin
while @continue_game

if @guesses_remaining.zero?
  puts "Correct letters guessed: #{@correct_letters.join(' ')}"
  puts "Incorrect letters guessed: #{@incorrect_letters.join(' ')}"
  puts "The word was #{word_arr.join('')}"
  break
end

puts "You have #{@guesses_remaining} guesses left, enter next guess!"
puts "Correct letters guessed: #{@correct_letters.join(' ')}"
puts "Incorrect letters guessed: #{@incorrect_letters.join(' ')}"
puts @blank_str
@guesses_remaining -= 1
guess = gets.chomp
while guess.length != 1
  puts 'Incorrect format, only enter a single letter!'
  guess = gets.chomp
end
guess_letter(guess, word_arr)
end
=end