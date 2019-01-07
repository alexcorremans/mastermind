class AI
  attr_reader :code, :tries

  def initialize
    @tries = 0
    @code = []
    @colors = ["red","green","yellow","blue","orange","purple"]
    @remaining_codes = @colors.repeated_permutation(4).to_a
  end

  def create_code
    4.times do
      @code.push(@colors[rand(6)])
    end
  end

  def check_code(guess,code=@code)
    pegs = {black: 0, white: 0}
    guess_to_check = guess.dup
    code_to_check = code.dup
    # black pegs
    black_positions = []
    guess_to_check.each_with_index do |color, i|
      if color == code[i]
        pegs[:black] += 1
        black_positions.push(i)
      end
    end
    # remove colors in correct positions to avoid white pegs for those
    black_positions.each do |pos|
      guess_to_check[pos] = nil
      code_to_check[pos] = nil
    end
    # white pegs
    guess_to_check.each do |color|
      if color == nil
        next
      end
      if code_to_check.include?(color)
        pegs[:white] += 1
        i = code_to_check.find_index(color)
        code_to_check.delete_at(i)
      end
    end
    return pegs
  end

  def guess
    @tries += 1
    choice = @remaining_codes[rand(@remaining_codes.length)]
    puts "Computer's guess: #{choice.join(' ')}"
    return choice
  end

  def receive_result(pegs,guess)
    @remaining_codes.delete_if do |code|
      pegs != check_code(code,guess)
    end
  end

  def won_game
    puts "The computer broke your code after #{@tries} attempts!"
  end

  def lost_game
    puts "The computer tried 12 times and didn't manage to break your code."
    puts "That's the end of this game, congratulations!"
    exit
  end
end
