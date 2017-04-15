require "yaml"

class Player
  attr_reader :name
  
  def initialize(game)
    @name = get_name
    @game = game
  end

  def get_name
    puts "Please enter your name:"
    name = gets.chomp
  end
  
  def make_guess
    puts "Type in a letter a-z. Enter '5' if you want to save the game and quit."
    while true
      guess = gets.chomp.downcase
      (return "save"; break) if (guess == "5")
      (puts "Type only one letter. Try again!"; redo) if !correct_input?(guess)
      (puts "You've already made this guess. Try a different letter!"; redo) if not_new_letter?(guess)
      break
    end
    puts "\nYour guess is the letter #{guess}."
    guess
  end

  def save?
    loop do
      puts "Press 'S' if you want to save the game and quit. Press 'C' to continue playing."
      input = gets.chomp.downcase
      if input == "s"
        return true
        break
      elsif input == "c"
        return false
        break
      else
        puts "Invalid option, please enter S or C."
      end
    end

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
  def initialize
    @player = Player.new(self)
    @guess = ""
    @secret_word = generate_secret_word
    @correct_letters = [" "]
    @incorrect_letters = []
    @turns_left = 10
    saves_directory
  end

  def menu
    system 'clear'
    puts "Hi #{@player.name}! Welcome to the Hangman Game!\n"
    puts "Would you like to...\n"
    puts "1. Start a new game"
    puts "2. Load a previous game\n"

    input = gets.chomp

    if input == "1"
      play
    elsif input == "2"
      load_game
    else
      puts "Please choose 1 or 2."
    end    
  end

  def load_game
    dirname = "hangman_saves"
    if Dir.glob(dirname+"/*").length > 0
      puts "Which game do you want to load?"
      puts Dir.glob("hangman_saves/*.yml").join("\n")
      choose_game_to_load
    else
      puts "No saved games! Starting a new game..."
      sleep(2)
      system 'clear'
      play
    end   
  end

  def choose_game_to_load
    puts "Type in the name of the file, e.g. for 'sample.yml' type 'sample'. Type 'new' to start a new game."
    loop do 
      filename = gets.chomp
      file = "hangman_saves/"+filename+".yml"
      if File.exists?(file)
        loaded_game = YAML::load(File.read(file))
        system 'clear'
        loaded_game.play
        break
      elsif filename == "new"
        puts "Starting a new game..."
        sleep(2)
        system 'clear'
        play
        break
      else
        puts "Invalid entry. Choose a file or type 'new'."
      end
    end
  end

  def saves_directory
    dirname = "hangman_saves"
    Dir.mkdir(dirname) unless File.exists?(dirname)
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

    suitable_words.sample.downcase
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
      draw_stickfigure
      puts "Yay! #{@player.name}, you guessed the word!"
      return true
    end
  end

  def draw_stickfigure
    turns = @turns_left
    case turns
    when 10
      puts "        "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
      puts "               "
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

  def save_or_continue
    userinput = @player.make_guess
    userinput == "save" ? (save_game; exit) : @guess = userinput
  end

  def save_game
    serialized_object = YAML::dump(self)
    puts "Enter a file name:"
    filename = gets.chomp.downcase
    saved_game = File.open("hangman_saves/#{filename}.yml","w")
    saved_game.puts(serialized_object)
    saved_game.close

    puts "Saving the game..."
    3.times do
      sleep(1)
      print "."
    end
    puts "\n"
  end

  
  def play
    puts "#{@player.name}, try to guess this word:"
    
    display_word(@correct_letters)
    
    while !game_over?
      puts "\nYou have #{@turns_left} incorrect guesses left!"
      draw_stickfigure
      (puts "Reminder: these letters are incorrect: #{@incorrect_letters.join(",")}") if @incorrect_letters.length > 0
      save_or_continue
      system 'clear'
      choice_of_paths
      display_word(@correct_letters)
    end
  end
end


Game.new.menu