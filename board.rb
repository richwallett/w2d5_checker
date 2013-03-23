class Board
  attr_accessor :pieces

  def initialize
    @surface = Array.new(8) { Array.new(8) { nil } }
    @pieces = []
  end

  def distribute(pieces)
    pieces.each { |piece| put(piece)}
  end

  def test_distribute(pieces)
    # red in front, blue at back, so... shift red, pop blue
    red_coords = [[5,1], [1,3], [3,3]]
    blue_coords = [[6,2], [4,4]]
    red_coords.each do |coord|
      red = pieces.shift
      red.position = coord
      put(red)
    end
    blue_coords.each do |coord|
      blue = pieces.pop
      blue.position = coord
      put(blue)
    end
  end

  def put(piece)
    self[piece.position] = piece
    @pieces << piece
  end

  def show
    print "  "
    ('a'..'h').each { |letter| print " #{letter} "}
    puts
    (0..7).each do |row|
      print "#{row} "
      @surface[row].each_with_index do |space, col|
        color = (row + col).even? ? :white : :green
        self[[row, col]].nil? ? show_blank_tile(color) : space.show(color)
      end
      puts
    end
  end

  def show_blank_tile(color)
    print "   ".colorize(background: color)
  end

  def move(moves)
    return false if self[moves[0]].nil?
    piece = self[moves.shift]
    return false unless piece.legal_move?(moves)
    perform_chain(moves, piece)

    true
  end

  def perform_chain(moves, piece)
    moves.each do |move|
      a_jump?(piece, move) ? piece.jump(move) : piece.slide(move)
    end
    piece.king if piece.on_king_row?

    true
  end

  def a_jump?(piece, move_seg)
    (piece.position[0] - move_seg[0]).abs +
      (piece.position[1] - move_seg[1]).abs == 4
  end

  def off_edge?(position)
    position[0] > 7 || position[0] < 0 || position[1] > 7 || position[1] < 0
  end

  def [] (pos_array)
    @surface[pos_array[0]][pos_array[1]]
  end

  def []= (pos_array, value)
    @surface[pos_array[0]][pos_array[1]] = value
  end
end