
class ProfesserPlayer

  def initialize(*)
    super
    @log = File.open('connect4.log', 'w')
    @log.sync = true
  end
  
  def name
    "Professer Player"
  end

  def puts(string)
    @log.write(string.to_s+"\n")
  end

  def column_n(state, n)
    state.map { |row| row[n] }
  end

  def make_move(state, column, colour)
    copy_board = state.dup
    puts "Playing column #{column} for #{colour}"
    puts copy_board
    5.downto(0) do |row|
      if copy_board[row][column] == :none
        copy_board[row][column] = colour
        break
      end
    end
    puts "After move:"
    puts copy_board
    copy_board
  end

  def winning_move?(state, colour)
    0.upto(6) do |column|
      possible_result = make_move(state, column, colour)
      return column if winner? possible_result
    end
    false
  end

  def clever_move?(state, colour)
    2.downto(1) do |n|
      0.upto(6) do |column|
        possible_result = make_move(state, column, colour)
        return column if consecutive? possible_result, n
      end
    end
    false
  end

  def flip_colour(colour)
    ([:red, :blue] - [colour]).first
  end

  def take_turn(state, colour)
    if opponent_move = winning_move?(state, flip_colour(colour))
      opponent_move
    elsif my_move = winning_move?(state, colour)
      my_move
    elsif clever_move = clever_move?(state, colour)
      clever_move
    else
      played = false
      while !played
        random_number = rand(7)
        return random_number if column_n(state, random_number)[0] == :none 
      end
    end
  end

  def winner?(board)

    board.each_index do |row|
      board[row].each_index do |col|
        next if board[row][col]==:none
        if col<board[row].size-3
          if board[row][col]==board[row][col+1] && board[row][col+1]==board[row][col+2] && board[row][col+2]==board[row][col+3]
            return board[row][col]
          end
        end
        if row<board.size-3
          if board[row][col]==board[row+1][col] && board[row+1][col]==board[row+2][col] && board[row+2][col]==board[row+3][col]
            return board[row][col]
          end
        end

        if row<board.size-3 && col<board[row].size-3
          if board[row][col]==board[row+1][col+1] && board[row+1][col+1]==board[row+2][col+2] && board[row+2][col+2]==board[row+3][col+3]
            return board[row][col]
          end
        end

        if row>3 && col<board[row].size-3
          if board[row][col]==board[row-1][col+1] && board[row-1][col+1]==board[row-2][col+2] && board[row-2][col+2]==board[row-3][col+3]
            return board[row][col]
          end
        end

      end
    end
    return nil
  end
  
  def consecutive?(board, n)

    board.each_index do |row|
      board[row].each_index do |col|
        next if board[row][col]==:none
        if col<board[row].size-n
          if 0.upto(n).each_cons(2).all? { |a, b| board[row][col+a] == board[row][col+b] }
            return board[row][col]
          end
        end
        if row<board.size-n

          if 0.upto(n).each_cons(2).all? { |a, b| board[row+a][col] == board[row+b][col] }
            return board[row][col]
          end
        end

        if row<board.size-n && col<board[row].size-n
          if 0.upto(n).each_cons(2).all? { |a, b| board[row+a][col+a] == board[row+b][col+b] }
            return board[row][col]
          end
        end

        if row>n && col<board[row].size-n
          if 0.upto(n).each_cons(2).all? { |a, b| board[row-a][col+a] == board[row-b][col+b] }
            return board[row][col]
          end
        end

      end
    end
    return nil
  end
end