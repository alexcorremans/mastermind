class Human
  attr_reader :tries

  def initialize
    @tries = 0
  end

  def create_code
    puts "Please make up a code and keep it in mind throughout the game."
  end

  def guess
    @tries += 1
    puts "Enter your choice of four colors, separated by a space:"
    choice = gets.chomp.split(' ')
    return choice
  end

  def receive_result(pegs,guess)
    puts "black pegs: #{pegs[:black]}"
    puts "white pegs: #{pegs[:white]}"
  end

  def check_code(guess)
    pegs = {black: 0, white: 0}
    puts "How many colors in the right place?"
    pegs[:black] = gets.chomp.to_i
    if pegs[:black] == 4
      return pegs
    else
      puts "How many colors are correct, but in the wrong place?"
      pegs[:white] = gets.chomp.to_i
    end
    return pegs
  end

  def won_game
    puts "You broke the code after #{@tries} attempts, congratulations!"
  end

  def lost_game
    puts "You've tried 12 times. Sorry!"
  end
end
