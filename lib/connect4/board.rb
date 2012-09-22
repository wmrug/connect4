module Connect4

  class Board
    
    attr_reader :board

    def initialize
      @board = Array.new(6) {Array.new(7, :none)}
      
    end

    def try(col, colour)
      return :invalid if @board[0][col] != :none
      
      5.downto(0) do |row|
        if @board[row][col] == :none
          @board[row][col] = colour
          break
        end
      end
      colour
    end

    def winner?
      
      @board.each_index do |row|
        @board[row].each_index do |col|
          next if @board[row][col]==:none
          if col<@board[row].size-3
            if @board[row][col]==@board[row][col+1] && @board[row][col+1]==@board[row][col+2] && @board[row][col+2]==@board[row][col+3]
              return @board[row][col]
            end
          end
          if row<@board.size-3
            if @board[row][col]==@board[row+1][col] && @board[row+1][col]==@board[row+2][col] && @board[row+2][col]==@board[row+3][col]
              return @board[row][col]
            end
          end

          if row<@board.size-3 && col<@board[row].size-3
            if @board[row][col]==@board[row+1][col+1] && @board[row+1][col+1]==@board[row+2][col+2] && @board[row+2][col+2]==@board[row+3][col+3]
              return @board[row][col]
            end
          end

          if row>3 && col<@board[row].size-3
            if @board[row][col]==@board[row-1][col+1] && @board[row-1][col+1]==@board[row-2][col+2] && @board[row-2][col+2]==@board[row-3][col+3]
              return @board[row][col]
            end
          end

        end
      end
      return nil
    end

    def draw?
      @board.each do |row|
        row.each do |cell|
          return false if cell==:none
        end
      end
      return true
    end

    def result(pos)
      x,y = pos
      @board[y][x]
    end

    def size
      @board.size
    end
    
    
  end
end