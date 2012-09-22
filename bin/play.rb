$:.unshift File.expand_path("../../lib", __FILE__)
require "connect4/game"
require "connect4/console_renderer"
require "connect4/util"
require "stringio"
require "digest/sha1"
require "forwardable"
require "drb"

DELAY = 1 #0.2
PORT = 4432

class PlayerClient
  extend Forwardable

  def initialize(secret, object)
    @secret = secret
    @object = object
  end

  def method_missing(m, *args)
    args.unshift(@secret)
    @object.__send__(m, *args)
  end

  def kill
    @object.stop(@secret)
  end
end

begin
  DRb.start_service

  player_server = File.expand_path("../player_server.rb", __FILE__)

  players = []
  2.times.each do |i|
    path = ARGV[i]
    port = PORT + i
    secret = Digest::SHA1.hexdigest("#{Time.now}#{rand}#{i}")
    system %{ruby #{player_server} "#{path}" #{port} #{secret} &}
    Connect4::Util.wait_for_socket('0.0.0.0', port)
    player = PlayerClient.new(secret, DRbObject.new(nil, "druby://0.0.0.0:#{port}"))
    player.stdin = $stdin
    players << player
  end

  winners = []

  11.times do |i|
    stderr = ""
    $stderr = StringIO.new(stderr)

    game = Connect4::Game.new(*players)
    renderer = Connect4::DeluxeConsoleRenderer.new
    $stdout << renderer.render(game)
    $stdout << stderr

    until game.winner || game.draw
      t0 = Time.now
      game.tick
      time_taken = Time.now - t0
      $stdout << renderer.render(game)
      $stdout << stderr
      sleep [DELAY - time_taken, 0].max
    end

    if game.winner
      name = game.winner.name
      if name=='Draw!'
        name = 'The player known as Draw!'
      end
      puts "", "#{game.winner.name} won round #{i+1}!"

      winners << name
    else
      puts "", "Round #{i+1} was a draw!" 
      winners << "Draw!"
    end
    sleep 3
    real_winners = winners.reject{|w| w=="Draw!"}
    break if real_winners.size > 2
    break if real_winners.size==2 && real_winners[0] == real_winners[1]

    players.reverse!
  end

  puts
  winners.each_with_index do |name, i|
    puts "Round #{i+1}. #{name}"
  end

  players.each &:kill


rescue Exception => e
  $stderr = STDERR
  raise e
ensure
  players.each &:kill
end
