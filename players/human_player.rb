
class HumanPlayer
  
  attr_accessor :stdin
  def name
    "Human Player"
  end

  def take_turn(state, colour)
    # puts "mines remaining: #{mines_remaining.inspect}"
    puts "column (0-6)?"
    y = stdin.gets.strip.to_i

  end
  
  
end