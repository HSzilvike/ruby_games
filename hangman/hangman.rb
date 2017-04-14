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
    @secret_word = ""
    @correct_letters = [" "]
    @incorrect_letters = []
    @turns_left = 10
  end

  def generate_secret_word
    #secret word will be chosen randomly
    words = File.read("5desk.txt").split()
    suitable_words = []

    words.each do |word|
      if ((word.size < 13) && (word.size > 4))
        suitable_words << word
      end
    end

    @secret_word = suitable_words.sample.downcase
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
      draw_stickfigure
      puts "You are out of turns! The secret word was #{@secret_word}. Game over!"
      return true
    end
    
    if @secret_word.split("").uniq.length == @correct_letters.length-1
      puts "Yay! #{@player.name}, you guessed the word!"
      return true
    end
  end

  def draw_stickfigure
    turns = @turns_left
    case turns
    when 9
      puts "        "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
      puts " //\\\\         "
    when 8
      puts "        "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 7
      puts "   ________     "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 6
      puts "   ________     "
      puts "  |        |     "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 5
      puts "   ________     "
      puts "  |        |     "
      puts "  |        O     "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 4
      puts "   ________     "
      puts "  |        |     "
      puts "  |        O     "
      puts "  |        |     "
      puts "  |        |    "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 3
      puts "   ________     "
      puts "  |        |     "
      puts "  |        O     "
      puts "  |       \\|     "
      puts "  |        |    "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 2
      puts "   ________     "
      puts "  |        |     "
      puts "  |        O     "
      puts "  |       \\|/     "
      puts "  |        |    "
      puts "  |             "
      puts "  |             "
      puts " //\\\\         "
    when 1
      puts "   ________     "
      puts "  |        |     "
      puts "  |        O     "
      puts "  |       \\|/     "
      puts "  |        |    "
      puts "  |       /      "
      puts "  |             "
      puts " //\\\\         "
    when 0
      puts "   ________     "
      puts "  |        |     "
      puts "  |        O     "
      puts "  |       \\|/     "
      puts "  |        |    "
      puts "  |       / \\     "
      puts "  |             "
      puts " //\\\\         "
    end
  
  end

  
  def play
    puts "#{@player.name}, try to guess this word:"
    generate_secret_word
    display_word(@correct_letters)
    
    while !game_over?
      puts "\nYou have #{@turns_left} incorrect guesses left!"
      draw_stickfigure
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