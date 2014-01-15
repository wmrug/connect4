class StupidPlayer

  def initialize
    @output = File.open( "/Users/will/output.txt", "a" )
  end
  
  def name
    "Hal"
  end

  def take_turn(state, colour)
    unless @previous_state.nil?
      last_column_played = difference(state, @previous_state, colour)
    else
      last_column_played = difference(state, state, colour)
    end
    @previous_state = state
    last_column_played 
  end

  def difference(current, previous, colour)
    retval = rand(7)
    (0..5).each {|row_index| 
      (0..6).each {|column_index|
        if current[row_index][column_index] != previous[row_index][column_index]
          if current[row_index][column_index] != colour
            @output.write ("column:#{column_index} \n")
            retval = column_index
          end
        end
      }
    }
    @output.flush
    retval
  end
  
end
