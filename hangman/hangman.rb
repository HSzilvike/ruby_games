class Player
  attr_reader :name
  
  def initialize(name, game)
    @name = name
    @game = game
  end
  
  def make_guess
    puts "Type in a letter a-z"
    while true
      guess = gets.chomp.downcase
      (puts "Type only one letter. Try again!"; redo) if !correct_input?(guess)
      (puts "You've already made this guess. Try a different letter!"; redo) if not_new_letter?(guess)
      break
    end
    puts "\nYour guess is the letter #{guess}."
    guess
  end
  
  private
  def correct_input?(input)
    (/^[a-z]$/) === input
  end
  
  def not_new_letter?(input)
    if (@game.correct_letters.include?(input)) || @game.incorrect_letters.include?(input)
      return true
    end
  end
end

class Game
  attr_reader :correct_letters, :incorrect_letters
  def initialize(player_name)
    @player = Player.new(player_name, self)
    @guess = ""
    @secret_word = "cuncimokuska"   #TODO : this needs to be chosen randomly, downcase
    @correct_letters = [" "]
    @incorrect_letters = []
    @turns_left = 10
  end
  
  def get_guess
    @guess = @player.make_guess
  end
  
  def evaluate_guess(letter)
    #return either correct or incorrect
    @secret_word.include?(@guess) ? (puts "This guess is correct!"; return :correct) : (puts "Sorry, this guess is not correct..."; return :incorrect)
  end
  
  def choice_of_paths
    evaluate_guess(@guess) == :correct ? correct_guess : incorrect_guess
  end
  
  def correct_guess
    @correct_letters.push(@guess)
  end
  
  def incorrect_guess
    @turns_left-=1
    @incorrect_letters.push(@guess)
  end
  
  
  def display_word(a)
    puts @secret_word.gsub(/[^#{a}]/, " _ ")
  end
  
  def game_over?
    if @turns_left < 1 
      puts "You are out of turns! Game over!"
      return true
    end
    
    if @secret_word.split("").uniq.length == @correct_letters.length-1
      puts "Yay! #{@player.name}, you guessed the word!"
      return true
    end
  end
  
  def play
    puts "#{@player.name}, try to guess this word:"
    display_word(@correct_letters)
    
    while !game_over?
      puts "\nYou have #{@turns_left} incorrect guesses left!"
      (puts "Reminder: these letters are incorrect: #{@incorrect_letters.join(",")}") if @incorrect_letters.length > 0
      get_guess
      choice_of_paths
      display_word(@correct_letters)
    end
  end
end

puts "Welcome to the Hangman Game! What's you name?"
username = gets.chomp
Game.new(username).play