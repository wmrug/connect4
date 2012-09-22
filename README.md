Connect4
==========

The game
--------

Long version: see [Wikipedia][1]

[1]: http://en.wikipedia.org/wiki/Connect_Four

Each turn, you must select a column to drop a piece of your colour in to. The piece will 'fall' vertically until it hits either another piece or the bottom of the board.

If there are now four pieces in a row (vertically, horizontally or diagonally) of your colour, you win.
If there is no space in that column for your piece, you lose.

The game will be drawn if there are no positions left to place pieces in to.
Play alternates between players until one of them wins, or the game is a draw.

### Additional rules

* The official interpreter is Ruby 1.9.2.
* The player will not have access to the game objects.
* The player may `require` Ruby source files from within a `lib` directory in the same place as the player file (i.e. `players/player.rb` can use `players/lib/foo/bar.rb` via `require "foo/bar"`.)
* A file should not implement more than one player class.

Implementation
--------------

This implementation is based on the ruby implementation for the game Battleships, as found [here](https://github.com/threedaymonk/battleship)

Play takes place on a 7x6 grid. Co-ordinates are given in the order _(x,y)_
and are zero-indexed relative to the top left, i.e. _(0,0)_ is the top left,
_(9,0)_ is the top right, and _(9,9)_ is the bottom right.

A player is implemented as a Ruby class. The name of the class must be unique
and end with `Player`. It must implement the following instance methods:

### name

This must return an ASCII string containing the name of the team or player.

### take_turn(state, colour)

`state` is a representation of the known state of the board, as
modified by the player’s moves. It is given as an array of arrays; the inner
arrays represent horizontal rows. Each cell may be in one of the following states:
`:none`, `:red`, `:blue`, where :red and :blue are the colours of the two players. 

`colour` is the colour that you are playing as, either :red or :blue, for evaluating the board. This will not change between turns, only between games.


`take_turn` must return a column number to drop a piece into, in the range 0-6.

The console runner
------------------

A console runner is provided. It can be started using:

    ruby bin/play.rb path/to/player_1.rb path/to/player_2.rb

Players are isolated using DRb.

A couple of very basic players are supplied: `StupidPlayer` chooses at random.
`Human Player` asks for input via the console.
