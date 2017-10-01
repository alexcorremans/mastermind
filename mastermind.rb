class Board
  def initialize
    @colors = ["red","green","yellow","blue","orange","purple"]
    @code = []
    @tries = 0
  end

  def start_game
    new_code
    puts "There are six colors to choose from: #{@colors.join(', ')}."
    puts "Duplicates are allowed, blanks aren't."
    puts "When you've made a choice, you'll receive black or white pegs."
    puts "Black means you have a color in the right place; white means you have a correct color but it's in the wrong place."
    play
  end

  private

  def new_code
    4.times do
      i = rand(6)
      @code.push(@colors[i])
    end
  end

  def play
    @tries += 1
    puts "Enter your choice of four colors, separated by a space:"
    choice = gets.chomp.split(' ')
    pegs = check_code(choice)
    display_result(pegs)
    next_try(pegs)
  end

  def check_code(choice)
    pegs = {black: 0, white: 0}
    code_to_check = @code.dup # reset code to check
    # black pegs
    black_positions = []
    choice.each_with_index do |color, i|
      if color == @code[i]
        pegs[:black] += 1
        black_positions.push(i)
      end
    end
    # remove colors in correct positions to avoid white pegs for those
    black_positions.each do |pos|
      choice[pos] = nil
      code_to_check[pos] = nil
    end
    # white pegs
    choice.each do |color|
      if color == nil
        next
      end
      if code_to_check.include?(color)
        pegs[:white] += 1
        code_to_check.delete(color)
      end
    end
    return pegs
  end

  def display_result(pegs)
    puts "black pegs: #{pegs[:black]}"
    puts "white pegs: #{pegs[:white]}"
  end

  def next_try(pegs)
    if code_found?(pegs)
      puts "You've won, congratulations!"
      puts "This was the code: #{@code.join(" ")}"
      exit
    elsif @tries == 12
      puts "You've tried 12 times. Sorry!"
      exit
    else
      play
    end
  end

  def code_found?(pegs)
    pegs[:black] == 4 ? true : false
  end
end


puts "Let's play Mastermind!"

board = Board.new
board.start_game
