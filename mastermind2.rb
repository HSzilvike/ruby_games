class Player
  COLORS = ["R", "B", "G", "Y", "W", "P"]
  attr_reader :name
  
  def initialize(name, board)
    @name = name
    @board = board
  end
  
  private
  def input_correct?(input)
    COLORS.include?(input)
  end
end

class HumanPlayer < Player
  def enter_colors
    colors = []
    puts "Choose 4 of the following: R, B, G, Y, W, P, one at a time."
    while colors.length < 4 do
      color = gets.chomp.to_s.upcase
      input_correct?(color) ? colors.push(color) : (puts "Please choose from R, B, G, Y, W or P")
    end
    colors
  end
  
  def make_guess
    enter_colors
  end
  
  def create_code #ez még nem kell
    enter_colors
  end
end

class ComputerPlayer < Player
  def create_code
    COLORS.sample(4)
  end
  
  
  def give_feedback(guess, code)
    feedback = []
    guess.each_with_index do |item, index|
      if item == code[index]
        feedback.push("2")
      elsif code.include?(item)
        feedback.push("1")
      else
        feedback.push("0")
      end
    end
    feedback
  end
end


class Board
  
  def initialize(name_human, name_computer)
    @codemaker = ComputerPlayer.new(name_computer, self)
    @codebreaker = HumanPlayer.new(name_human, self)
    @secretcode = []
    @guess = []
    @num_round = 1
  end
  
  def get_code
    puts "#{@codemaker.name}, create a secret code!"
    @secretcode = @codemaker.create_code
    puts "#{@codemaker.name} has created the secret code!"
  end
  
  def get_guess
    puts "#{@codebreaker.name}, make a guess!"
    @guess = @codebreaker.make_guess
    puts "The guess is #{@guess}"
  end
  
  def get_feedback
    puts "#{@codemaker.name}, give a feedback on this guess!"
    @feedback = @codemaker.give_feedback(@guess, @secretcode)
    puts "The feedback is #{@feedback}. \nMeaning: 2: color & position ; 1: color ; 0: not included"
  end
  
  def game_over
    return :winner if (@guess == @secretcode)
    return :over if (@num_round > 4)
    false
  end
  
  def game_over_message
    return "Right guess! #{@codebreaker.name} wins!" if game_over == :winner
    return "No more turns! #{@codemaker.name} wins!" if game_over == :over
  end
  
  def play
    get_code
    p @secretcode # ezt majd ki kell törölni !!!!
    
    while true
      puts "Turn #{@num_round}/5"
      get_guess
      get_feedback
      if game_over
        puts game_over_message
        return
      else
        @num_round += 1
      end
    end
  end
end

Board.new("Muci", "MastermindBot").play









