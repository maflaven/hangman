require 'byebug'

class Game
  TURNS = 10

  def initialize(checker, guesser)
    @checker = checker
    @guesser = guesser
    @occluded_word = Array.new(checker.secret_word.length) { '_' }
  end

  def display_board(word = nil)
    if word
      puts "Secret word: #{word.join(' ')}"
    else
      puts "Secret word: #{@occluded_word.join(' ')}"
    end
  end

  def check_letter(guess)
    @occluded_word.each_index do |space|
      @occluded_word[space] = guess if @checker.secret_word[space] == guess
    end
  end

  def play
    turns = TURNS

    puts "Welcome to hangman!"

    until turns == 0 || game_won?
      display_board
      check_letter(@guesser.guess)
      turns -= 1
    end

    display_board(@checker.secret_word.split(''))

    if game_won?
      puts "You saved him... for now..."
    else
      puts "Justice is served. The crows shall feast!"
    end
  end

  def game_won?
    if @occluded_word.include?('_')
      false
    else
      true
    end
  end

end

class Computer
  attr_reader :secret_word

  def initialize(dictionary = 'dictionary.txt')
    @dictionary = File.readlines(dictionary).map(&:chomp)
    @secret_word = pick_secret_word
    @guessed_letters = []
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
  end

  def receive_secret_length
  end

  def guess
  end
end

class Human
  attr_reader :secret_word

  def initialize(dictionary = 'dictionary.txt')
    @dictionary = File.readlines(dictionary).map(&:chomp)
    @secret_word = nil
    @guessed_letters = []
  end

  def pick_secret_word
    puts "Pick a secret word (must be in the dictionary):"
    @secret_word = gets.chomp.downcase

    until @dictionary.include?(@secret_word)
      puts "That word isn't in the dictionary. Pick again:"
      @secret_word = gets.chomp.downcase
    end
  end

  def receive_secret_length
  end

  def guess
    guess = gets.chomp.downcase

    until ((guess =~ /[a-z]/) == 0) && (guess.length == 1) && !(@guessed_letters.include?(guess))
      puts "Your guess must be a letter (and one you haven't already picked)."
      puts "Guess again:"
      guess = gets.chomp.downcase
    end

    @guessed_letters << guess

    guess
  end
end

if __FILE__ == $PROGRAM_NAME
  computer = Computer.new
  human = Human.new
  game = Game.new(computer, human)

  game.play
end
