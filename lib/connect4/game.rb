require 'connect4/board'

module Connect4

  class Game
    def initialize(*players)
    
      @board = Board.new

      @players = players.map{|p| [p, colours[players.index(p)]]}
      @state = Array.new(6) {Array.new(7, :none)}

      @turn = 0

    end

    attr_reader :winner, :draw

    def tick
      @player, colour = @players[@turn % 2]
      @opponent = @players[(@turn+1) % 2][0]
      col = @player.take_turn(@state, colour)
      
      result = update_state(col, colour)

      
      @turn += 1

    end
    
    def names
      @players.map{|p| p.first.name}
    end

    def colours
      [:red, :blue]
    end

    def report
      @board.board
    end

  private
    def update_state(col, colour)

      result = @board.try(col, colour)

      if result == :invalid
        @winner = @opponent
      elsif @board.winner?
        @winner = @player
      elsif @board.draw?
        @draw = true
      end
      
      return result
    end
  end
end