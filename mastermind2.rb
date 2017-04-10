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
  
  def feedback_input_correct?(input)
    ["0","1","2"].include?(input)
  end
  
  def human_feedback_correct?(guess, code, feedback)
    correct_fb = correct_feedback(guess, code)
    correct = true
    feedback.each_with_index do |item, index|
      if (item == correct_fb[index])
        next
      else
        correct = false
      end
    end
    return correct
  end
  
  def correct_feedback(guess, code)
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
  
  def create_code
    enter_colors
  end
  
  def give_feedback(guess, code)
    puts "Please enter 2 if color & position are right; 1 if the color is right ; 0 if the color is not included in the secret code, for each guess, one at a time."
    puts "Reminder: your secret code is #{code}."
    feedback = []
    while feedback.length < 4 do
      input = gets.chomp
      feedback_input_correct?(input) ? feedback.push(input) : (puts "Please enter 0, 1 or 2"; next)
      human_feedback_correct?(guess, code, feedback) ? next : (puts "This feedback seems to be incorrect. Check again!" ; feedback.pop)
    end
    feedback
  end

end

class ComputerPlayer < Player
  def create_code
    COLORS.sample(4)
  end
  
  def make_guess
    @board.feedback.empty? ? random_guess(4) : evaluate_feedback
  end
  
  def evaluate_feedback
    newguess = []
    (0..3).each do |i|
    (@board.feedback[i] == "2") ? newguess.push(@board.guess[i]) : newguess.push(random_guess(1).join)
    end
    newguess
  end
  
  def random_guess(n)
    COLORS.sample(n)
  end
  
  def give_feedback(guess, code)
    correct_feedback(guess, code)
  end
  
end


class Board
  attr_reader :feedback, :guess
  def initialize(breaker_class, breaker_name, maker_class, maker_name)
    @codemaker = maker_class.new(maker_name, self)
    @codebreaker = breaker_class.new(breaker_name, self)
    @secretcode = []
    @guess = []
    @feedback = []
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
    #p @secretcode  UNCOMMENT FOR DEBUGGING
    
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


puts "Welcome to Mastermind! Please enter your name:"
username = gets.chomp
puts "Do you want to make or break the secret code? Enter M or B"
game_type = gets.chomp.to_s.upcase

  case game_type
  when "M"
    Board.new(ComputerPlayer, "MastermindBot", HumanPlayer, username).play
  when "B"
    Board.new(HumanPlayer, username, ComputerPlayer, "MastermindBot").play
  else
    puts "Please enter M or B"
  end











