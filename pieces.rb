
class Piece
  attr_reader :color
  attr_accessor :position

  DOWN_VECTORS = [[1, 1], [1, -1]]
  UP_VECTORS = [[-1, 1], [-1, -1]]

  def initialize(color, position, board)
    @color = color
    @position = position
    @vectors = @color == :red ? DOWN_VECTORS : UP_VECTORS
    @king_row = @color == :red ? 7 : 0
    @board = board
    @icon = " * "
  end

  def show(background)
    print @icon.colorize(color: @color, background: background)
  end

  def legal_move?(moves)
    orig_position = self.position

    moves.each do |move|
      # if any move in the chain doesn't work then return false
      return false if @board.off_edge?(move)

      next if slides_to?(move)
      next if jumps_to?(move)

      return false
    end

    @position = orig_position
    true
  end

  def slides_to?(next_move)
    @vectors.each do |vector|
      pos_move = self.add_vector(vector)
      if pos_move == next_move && @board[pos_move].nil?
        return @position = next_move
      end
    end

    false
  end

  def jumps_to?(next_move)
    @vectors.each do |vector|
      pos_move = self.add_vector(vector, 2)
      pos_jumped = self.add_vector(vector)
      if pos_move == next_move && @board[pos_jumped].is_a?(Piece)
        return @position = next_move
      end
    end

    false
  end

  def add_vector(vector, multi = 1)
    [ @position[0] + vector[0] * multi, @position[1] + vector[1] * multi ]
  end

  def jump(move)
    dead_piece = @board[[(@position[0] + move[0]) / 2, (@position[1] + move[1]) / 2]]

    @board[@position] = nil
    @position = move
    @board[move] = self

    self.kill(dead_piece)
  end

  def slide(move)
    @board[@position] = nil
    @position = move
    @board[move] = self
  end

  def kill(piece)
    @board[piece.position] = nil
    @board.pieces.delete(piece)
    piece.position = nil
  end

  def on_king_row?
    @position[0] == @king_row
  end

  def king
    @vectors += @color == :red ? UP_VECTORS : DOWN_VECTORS
    @icon = "***"
  end
end