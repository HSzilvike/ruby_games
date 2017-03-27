class Game

  def initialize
  $player1 = Player.new("Player 1", "X")
  $player2 = Player.new("Player 2", "O")
  
  @@a = [1,2,3]
  @@b = [4,5,6]
  @@c = [7,8,9]
  end

def self.show_board
  p @@a.join("  ")
  p @@b.join("  ")
  p @@c.join("  ")

end

def self.decisionmaking
  
      validround = false
    while !validround do
      decision = gets.chomp.to_i
      if (((1..3).include? decision) && (@@a[(decision-1)].is_a? Integer))
      @@a[(decision-1)] = $currentsign
      validround = TRUE
      elsif (((4..6).include? decision) && (@@b[(decision-4)].is_a? Integer))
      @@b[(decision-4)] = $currentsign
      validround = TRUE
      elsif (((7..9).include? decision) && (@@c[(decision-7)].is_a? Integer))
      @@c[(decision-7)] = $currentsign
      validround = TRUE
      else
       puts "Don't try to cheat!! Choose one of the displayed numbers!"
      end
    end
    
      
      Game.show_board
      Game.gameover?
    
  end

  def self.nextround(whichplayer)
    
    puts "It's #{whichplayer.name}'s turn!"
    $currentsign = whichplayer.sign
    Game.decisionmaking
    
  end


  def self.flow
  $gameflow = TRUE
    
  while $gameflow do
  Game.nextround($player1)
  $gameflow ? Game.nextround($player2) : break
  end

  end
  
  
  def self.someonewon
    case
    when ([@@a[0],@@a[1],@@a[2]].uniq.length == 1)
      winnersign = [@@a[0],@@a[1],@@a[2]].uniq
    when ([@@b[0],@@b[1],@@b[2]].uniq.length == 1)
      winnersign = [@@b[0],@@b[1],@@b[2]].uniq
    when ([@@c[0],@@c[1],@@c[2]].uniq.length == 1)
      winnersign = [@@c[0],@@c[1],@@c[2]].uniq
      
    when ([@@a[0],@@b[0],@@c[0]].uniq.length == 1)  
      winnersign = [@@a[0],@@b[0],@@c[0]].uniq
    when ([@@a[1],@@b[1],@@c[1]].uniq.length == 1)
      winnersign = [@@a[1],@@b[1],@@c[1]].uniq
    when ([@@a[2],@@b[2],@@c[2]].uniq.length == 1)
      winnersign = [@@a[2],@@b[2],@@c[2]].uniq
   
    when ([@@a[0],@@b[1],@@c[2]].uniq.length == 1) 
      winnersign = [@@a[0],@@b[1],@@c[2]].uniq
    when ([@@a[2],@@b[1],@@c[0]].uniq.length == 1)  
      winnersign = [@@a[2],@@b[1],@@c[0]].uniq
  else
        
    end
      
    if winnersign == ["X"]
      $player1.winner = TRUE 
    elsif winnersign == ["O"]
      $player2.winner = TRUE
    else
    end
  
  
  end
  
  def self.gameover?
    
  Game.someonewon
    
  if ($player1.winner)
    puts "Congratulations! #{$player1.name} is the winner!"
    $gameflow = false
    return true
  elsif ($player2.winner)
    puts "Congratulations! #{$player2.name} is the winner!"
    $gameflow = false
    return true
  else
  end
  
  
  if ((@@a+@@b+@@c).none? {|n| n.is_a? Integer})
        $gameflow = false
        puts "No winner! Try again!"
        return true
     else
     end
  
    
  end 
  
end

class Player
  
  attr_reader :name
  attr_reader :sign
  attr_accessor :winner
  
   def initialize(name, sign)
    @name = name
    @sign = sign
    @winner = FALSE
    puts "#{name} (sign #{sign}) is ready to play!"
  end
  
end



#puts "Type start_game to play!"


def start_game
  puts "Let's play Tic-Tac-Toe!"
  Game.new
  puts "Choose one of the displayed numbers to make your decision!"
  Game.show_board
  Game.flow
 
end


start_game