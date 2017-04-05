class Game
  attr_reader :board
  def initialize(name1, name2)
    @players =[Player.new(name1, "X", self), ComputerPlayer.new(name2, "O", self)]
    @current_player, @other_player = @players.shuffle
    @board = (0..9).to_a
  end
  
  def play
    show_board
    
    loop do
      puts "It is your turn #{@current_player.name} (#{@current_player.marker})! Choose a position!"
      update_board!
      if won?
        puts "#{@current_player.name} you win!"
        return show_board
      elsif tie?
        puts "The board is full! It's a draw!"
        return show_board
      end
      
      switch_player!
    end
  end
  
  def switch_player!
    @current_player, @other_player = @other_player, @current_player
  end
  
  def show_board
    puts @board[1..3].join ("    ")
    puts @board[4..6].join ("    ")
    puts @board[7..9].join ("    ")
  end
  
  def update_board!
    loop do
      choice = @current_player.choose_position
      if free_cell?(choice) 
        @board[choice] = @current_player.marker
        return show_board
      else
        puts "This cell is not free! Choose a different one!"
      end
    end
  end
  
  def free_cell?(position)
    @board[position].is_a? Integer
  end
  
  def free_cells
   (1..9).select { |i| free_cell?(i) }
  end
  
  def tie?
    free_cells == []
  end
  
  def won?
    winning_positions = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
    (0..7).any? { |n| winning_positions[n].all? { |i| @board[i] == @current_player.marker } }
  end
end


class Player
  attr_reader :name, :marker
  def initialize(name, marker, game)
    @name = name
    @marker = marker
    @game = game
  end
  
  def choose_position
    choice = gets.chomp!.to_i
  end
end

class ComputerPlayer < Player
  def choose_position
   @game.free_cells.sample
  end
end

Game.new("Muci", "TicTacBot").play








