class Player
  def initialize(color)
    @color = color
  end

  def move

  end
end

class HumanPlayer < Player
  def move
    loop do
      puts "#{@color},".capitalize.colorize(@color)
      puts "Enter move coordinates: start end : (e.g. 2a 3b)"
      input = gets.chomp.split

      if input.select { |str| !(str =~ /\A[0-7][a-hA-H]\z/) }.empty? &&
                                                      input.length > 1
        input.map! { |str| str.split('') }
        return input.map { |pos| [pos[0].to_i, pos[1].downcase.ord - 97]}
      end
      puts "Bad input, try again"
    end
  end
end