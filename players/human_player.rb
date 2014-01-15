
class HumanPlayer
  
  attr_accessor :stdin
  def name
    "Human"
  end

  def take_turn(state, colour)
    puts state.inspect
    choice = detect_winning_column(state, colour)
    choice ||= detect_blocking_column(state, colour)
    choice ||= detect_best_column(state, colour)

    while full?(state, choice)
      choice = rand(7)
    end
    choice
  end

  def full?(state, choice)
    state[0][choice] != :none
  end

  def column(state, column)
    mapped_column = (0..5).map do |row|
      state[row][column]
    end
    mapped_column
  end

  def detect_winning_column(state, colour)
    scores_arr = (0..6).map do |possible_column|
      test = column(state, possible_column).select {|x| x != :none}
      count = 0
      while test[count] == colour
        count += 1
      end
      [possible_column, count]
    end
 #   puts scores_arr.inspect
    winning_column = scores_arr.detect do |arr|
      arr[1] == 3
    end
    winning_column[0] if winning_column
  end

  def detect_best_column(state, colour)
    scores_arr = (0..6).map do |possible_column|
      test = column(state, possible_column).select {|x| x != :none}

      count = 0
      while test[count] == colour
        count += 1
      end
      [possible_column, count]
    end
#    puts scores_arr.inspect
    highest = 0
    highest_column = rand(7)    
    scores_arr.each do |arr|
      if arr[1] > highest
        highest = arr[1]
        highest_column = arr[0]
      end
    end
    highest_column
  end


  def detect_blocking_column(state, colour)
    scores_arr = (0..6).map do |possible_column|
      test = column(state, possible_column).select {|x| x != :none}
      count = 0
      while test[count] != colour && count < test.size
        count += 1
      end
      [possible_column, count]
    end
    blocking_column = scores_arr.detect do |arr|
      arr[1] == 3
    end
    blocking_column[0] if blocking_column
  end
  
  
end
