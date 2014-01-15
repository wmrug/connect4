class OptimusPrimePlayer
  attr_accessor :state, :colour, :op_colour


  require 'logger'
  def initialize
    file = File.open('out.log', File::WRONLY | File::APPEND)
    @logger = Logger.new(file)
  end

  def name
    "OPTIMUS PRIME"
  end

  def logger
    @logger
  end

  def take_turn(state, colour)
    self.state = state
    self.colour = colour
    op_colour = colour == :blue ? :red : :blue
    self.op_colour = op_colour

    if m = winning_move(colour)
      return m
    elsif m = winning_move(op_colour)
      return m
    end

    return play_simple_move if play_simple_move
    @logger.error(state)

    play_safe_move
  end

  def play_simple_move
    (0..6).each do |i|
      in_column = (0..5).detect {|x|
        @logger.error x
        @logger.error i
        state[x][i] == op_colour
      }
      return i if !in_column
    end
    return false
  end

  def play_safe_move
    while true
      var = rand(7)
      return var if state[0][var] == :none
    end
  end

  def winning_move(c)
    move = winning_move_row(c)
    move ||= winning_move_column(c)
    return move if move
    return false
  end

  def winning_move_column(c)
    tr_state = state.transpose
    (0..6).each do |x|
      row = tr_state[x]
      (0..2).each do |i|
        result = row[i..i+3].inject(Hash.new(0)) {|mem, i| mem[i] += 1; mem}
        if result[c] == 3 && result[:none] == 1
          return x
        end
      end
    end
    return false
  end

  def winning_move_row(c)
    (0..5).each do |x|
      row = state[x]
      (0..3).each do |i|
        result = row[i..i+3].inject(Hash.new(0)) {|mem, i| mem[i] += 1; mem}
        if result[c] == 3 && result[:none] == 1
          return row[i..i+3].rindex(:none) + i
        end
      end
    end
    return false
  end

end
