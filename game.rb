require './player.rb'
require './board.rb'
require './pieces.rb'
require 'colorize'
require 'debugger'

# NEED TO FIX:
# USER CAN ENTER AN ARRAY OF MOVES INCLUDING MULTIPLE SLIDES OR SLIDES
# AFTER JUMPS.  STOP THAT FROM HAPPENING


class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @winner = nil
  end

  def run
    @board.test_distribute(new_game_pieces)
    #@board.distribute(new_game_pieces)
    make_players
    @current_player = @player1

    until game_over?
      play_game
    end

    display_results
  end

  def new_game_pieces
    pieces = []
    pieces += new_team(:red, (0..2), 0)
    pieces += new_team(:blue, (5..7), 1)
    pieces
  end

  def new_team(color, row_range, i)
    pieces = []
    row_range.each do |row|
      [0+i ,2+i, 4+i, 6+i].each do |col|
        pieces << Piece.new(color, [row,col], @board)
      end

      i = (i + 1) % 2
    end
    pieces
  end

  def make_players
    @player1 = HumanPlayer.new(:red)
    @player2 = HumanPlayer.new(:blue)
  end

  def switch_players
    @current_player = (@current_player == @player2 ? @player1 : @player2)
  end

  def play_game
    @board.show
    move = false
    until move
      move = @current_player.move
      move = @board.move(move)
      puts "\ninvalide move!!" if move == false
    end
    switch_players
  end

  def display_results
    puts "#{@winner} wins!"
  end

  def game_over?
    @winner = :blue if @board.pieces.select { |piece| piece.color == :red }.empty?
    @winner = :red if @board.pieces.select { |piece| piece.color == :blue }.empty?
    @winner
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.run
end