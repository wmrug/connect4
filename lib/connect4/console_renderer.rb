# encoding: utf-8

require "stringio"
require "colored"

module Connect4
  class ConsoleRenderer
    RESET = "\e[2J\e[H"

    def render(game)
      output = StringIO.new(buffer = "")
      names   = game.names
      colours = game.colours
      report = game.report

      output << RESET

      output.puts

      render_board(output, report)
      output.puts

      2.times.each do |i|
        render_player(output, names[i], colours[i])
      end

      buffer
    end

  private
    ICONS = {
      :none   => ". ",
      :blue   => "X ".blue,
      :red    => "X ".red
    }

    def render_row(row)
      row.map{ |name| icon(name) }.join
    end

    def icon(name)
      ICONS[name] || name
    end

    def render_board(output, board)
      board.each do |row|
        output << render_row(row)
        output.puts
      end
    end

    def render_player(output, name, colour)
      output.puts "#{name} (#{icon(colour)})", ""

    end
  end

  class DeluxeConsoleRenderer < ConsoleRenderer

    ICONS = {
      :none    => "· ",
      :red     => "█ ".red,
      :blue    => "█ ".blue
    }

  private
    def icon(name)
      ICONS[name] || "#{name} "
    end

  end
end
