class DoomPlayer
  WIN_WEIGHT_GRID = [
    [3,4,5,7,5,4,3],
    [4,6,8,10,8,6,4],
    [5,8,11,15,11,8,5],
    [5,8,11,15,11,8,5],
    [4,6,8,10,8,6,4],
    [3,4,5,7,5,4,3],
  ]

  def initialize
    @last_move       = []
    # @our_positions   = []
    # @their_positions = []
    @total_moves = 0
  end

  def name
    "Doom"
  end

  def take_turn(state, colour)
    record_new_status(state, colour)
    return 3 if board_empty?
    pick_position
  end

  def record_new_status(state, colour)
    @state, @our_colour  = state, colour
    @their_colour = @our_colour == :red ? :blue : :red
    @total_moves += 1
    record_positions
  end

  def find_empty_row
    5.downto(0).each do |y|
      return y if row_empty?(y)
    end
  end

  def pick_position
    @y_level = find_empty_row
    count_vertical if (0..3).include?(@y_level)
    if col = count_horizontal_opponent_lengths
      col
    elsif count_vertical
      puts "hello"
      col = count_vertical_lengths
    else
      # play from weighting table
      col = rand(7)
    end
    if column_full?(col)
      fallback_position
    else
      col
    end
  end

  def count_vertical_lengths
    rand(7)
  end

  def fallback_position
    [3,2,4,5,1,6,0].each do |pos|
      return pos unless column_full?(pos)
    end
  end

  def count_horizontal_opponent_lengths
    line = []
    5.downto(@y_level) do |y|
      (0..6).each do |x|
        # early return to block opponent
        return x if @state[x,y] == :none && line.size == 3
        if @state[x,y] == @our_colour
          line = []
          next
        elsif @state[x,y] == :none
          line = []
          next
        else # their colour
          line << [x,y]
        end
      end
    end
  end

  def record_positions
    @our_positions   = []
    @their_positions = []
    @free_slots      = []
    (0..6).each do |x|
      (0..5).each do |y|
        case @state[x,y]
        when @colour
          @our_positions.push [x,y]
        when :none
          @free_slots.push [x,y]
        else
          @their_positions.push [x,y]
        end
      end
    end
  end

  def board_empty?
    @state.flatten.all? {|i| i == :none }
  end

  def column_full?(column)
    @state[column][0] != :none
  end

  def row_empty?(row_level)
    res = []
    (0..6).each do |x|
      res << @state[x,row_level]
    end
    res.all? {|i| i == :none }
  end
end

