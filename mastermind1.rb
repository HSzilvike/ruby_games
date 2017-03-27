colors = ["red", "blue", "green", "yellow", "black", "white"]
$choice = colors.sample(4)

def make_guess
  
  guess = Array.new
  puts "Make a guess! Type in 4 colors. The choices: red, blue, green, yellow, black or white"
  
  i=0
 while (guess.length < 4) do
  somestring = gets.chomp.downcase
  if ["red", "blue", "green", "yellow", "black", "white"].include?(somestring)
     guess[i] = somestring
     i+=1
   else
     puts "Please choose from: red, blue, green, yellow, black or white"
    end
  end
  
  puts "Your guess is #{guess}."
  
  $guess = guess
end

def feedback(choice, guess)
  
  matching_colors = 0
  matching_position = 0
  
  
  if choice == guess
    puts "Congratulations! You win!"
    return $gameover = TRUE
  else
    $gameover = FALSE
  end
  
  fb_detailed = []
  
  i=0
  4.times do |i|
    if (guess[i] == choice[i])
      matching_position +=1
      fb_detailed[i] = "yep!"
    end
    
    if choice.include?(guess[i])
    matching_colors+=1
    (fb_detailed[i] != "yep!") ? fb_detailed[i] = "color" : nil
    end
    
   fb_detailed[i] ||= "nope"
  
    i+=1
  end
  
  puts "Number of matching colors: #{matching_colors}."
  puts "Number of matching positions: #{matching_position}."
  #puts "For debugging: choice #{choice}."
  puts "The feedback: #{fb_detailed}"
end




def game
  
12.times do
  make_guess
  feedback($choice, $guess)
  break if $gameover
  end
  
($gameover == FALSE) ? (puts "You lose! The solution is #{$choice}. Try again!") : nil
  
end


game




