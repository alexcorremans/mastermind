class Board
  def initialize
    @@colors = ["red","green","yellow","blue","orange","purple"]
  end

  def start_game
    puts "Let's play Mastermind!"
    puts "For clarity, let's define some rules first:"
    puts "A code consists of four colors."
    puts "There are six colors to choose from: #{@@colors.join(', ')}."
    puts "Duplicates are allowed, blanks aren't."
    puts "The codebreaker has twelve guesses."
    puts "Would you like to be the codemaker (1) or codebreaker (2)?"
    role = gets.chomp
    while true
      if role == "1"
        Codemaker.new.start
        break
      elsif role == "2"
        Codebreaker.new.start
        break
      else
        puts "Not a valid choice. Try again"
        role = gets.chomp
      end
    end
  end
end

class Codebreaker < Board
  def initialize
    @code = []
    @tries = 0
  end

  def start
    new_code
    puts "You chose to try and break the code!"
    puts "When you've made a choice, you'll receive black or white pegs."
    puts "Black means you have a color in the right place; white means you have a correct color but it's in the wrong place."
    play
  end

  private

  def new_code
    4.times do
      i = rand(6)
      @code.push(@@colors[i])
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
    if pegs[:black] == 4
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

end

class Codemaker < Board
  def initialize
    @tries = 0
    @attempts = []
    @colors = @@colors.dup
  end

  def start
    puts "You chose to make the code and see if the computer can break it..."
    #create_code
    first_guess
  end

  private

  def create_code
    puts "Enter four colors, separated by a space:"
    @code = gets.chomp.split(' ')
  end

  def first_guess
    @tries += 1
    @choice = []
    4.times do
      i = rand(6)
      @choice.push(@colors[i])
    end
    @attempts.push(@choice)
    play(@choice)
  end

  def play(choice)
    puts "Computer's guess: #{choice.join(' ')}"
    pegs = ask_pegs(choice)
    next_try(pegs)
  end

  def ask_pegs(choice)
    pegs = {black: 0, white: 0}
    puts "How many colors in the right place?"
    pegs[:black] = gets.chomp.to_i
    if pegs[:black] == 4
      puts "The computer broke your code after #{@tries} attempts!"
      exit
    end
    puts "How many colors are correct, but in the wrong place?"
    pegs[:white] = gets.chomp.to_i
    return pegs
  end

  def next_try(pegs)
    if @tries == 50
      puts "The computer tried 50 times and didn't manage to break your code."
      puts "That's the end of this game, congratulations!"
      exit
    else
      guess(pegs)
    end
  end

  def tried_before
    @attempts.include?(@choice)
  end

  def guess(pegs)
    @tries += 1
    @choice = [nil, nil, nil, nil]
    last_attempt = @attempts.last

    if (pegs[:black] + pegs[:white]) == 4
      @colors.delete_if do |color|
        !last_attempt.include?(color)
      end
    end

    if pegs[:black] == 3
      (0..3).reverse_each do |pos| # pos will be the position of the color to change
        indexes = (0..3).to_a
        indexes.delete(pos)
        for i in indexes # indexes give the index of the colors to keep
          @choice[i] = last_attempt[i]
        end
        colors = @colors.dup
        colors.delete(last_attempt[pos])
        colors.each do |color|
          @choice[pos] = color
          if !tried_before #if choice is new, stop the loop
            break
          else
            @choice[pos] = nil #reset to show choice hasn't been made yet
          end
        end
        break if !@choice.include? nil #if new choice, stop the loop
      end

    elsif pegs[:black] == 2
      positions = [[0,1],[1,2],[2,3],[3,0],[0,1],[1,2]]
      for j in 0..3 # the loop is written this way to be able to 'cycle through' all possibilities
        # keep colors in two positions of last attempt
        keep = positions[j]
        keep.each do |i|
          @choice[i] = last_attempt[i]
        end
        change = positions[j+2]
        first = change[0]
        second = change[1]

        if pegs[:white] == 0 # loop through colors for remaining two positions
          colors = @colors.dup
          colors.delete(last_attempt[first])
          colors.delete(last_attempt[second]) # don't use these colors
          colors.each do |x|
            @choice[first] = x
            colors.each do |y|
              @choice[second] = y
              break if !tried_before #if new choice, stop inner loop
            end
            if !tried_before #if new choice, stop this loop too
              break
            else
              @choice[first] = nil # set a value to nil so the outer loop will keep going
            end
          end

        elsif pegs[:white] == 1
          colors = @colors.dup
          if last_attempt[first] == last_attempt[second]
            next
          end
          colors.delete(last_attempt[first]) # delete one color from possible choices
          @choice[first] = last_attempt[second] # switch the other
          colors.each do |x|
            @choice[second] = x
            break if !tried_before
          end
          if tried_before
            colors = @colors.dup
            colors.delete(last_attempt[second])
            @choice[second] = last_attempt[first]
            colors.each do |x|
              @choice[first] = x
              break if !tried_before
            end
            if !tried_before
              break
            else
              @choice[first] = nil
            end
          end

        else # 2 blacks, 2 whites
          # switching two colors
          @choice[first] = last_attempt[second]
          @choice[second] = last_attempt[first]
          if !tried_before
            break
          else
            @choice[first] = nil
          end
        end
        break if !@choice.include? nil #if new choice, stop the loop, otherwise keep going
      end

    elsif pegs[:black] == 1 && pegs[:white] == 0
      positions = [[0,1,2,3],[1,2,3,0],[2,3,0,1],[3,0,1,2]]
      positions.each do |position|
        @choice[position[0]] = last_attempt[position[0]] # keep one color
        colors = @colors.dup
        for i in 1..3
          colors.delete(last_attempt[position[i]]) # don't use other colors
        end
        # now run through the other values
        colors.each do |x|
          @choice[position[1]] = x
          colors.each do |y|
            @choice[position[2]] = y
            colors.each do |z|
              @choice[position[3]] = z
              break if !tried_before # if new choice, stop the loop
            end
            break if !tried_before
          end
          if !tried_before
            break
          else
            @choice[position[1]] = nil
          end
        end
        break if !@choice.include? nil
      end

    elsif pegs[:black] == 1 && pegs[:white] == 3
      # keep 1, move around 3 others
      for pos in 0..3
        indexes = (0..3).to_a
        indexes.delete(pos)
        colors = @colors.dup
        @choice[pos] = last_attempt[pos]
        rest = []
        for i in indexes
          rest.push(last_attempt[i]) # list of colors we'll use to permutate
        end
        choices = rest.permutation(3).to_a
        choices.each do |choice|
          for i in indexes
            @choice[i] = choice[i]
            if @choice[i] == last_attempt[i]
              incomplete_swap = true
            end
          end
          next if incomplete_swap
          if !tried_before
            break
          else
            @choice[pos] = nil
          end
        end
        break if !@choice.include? nil
      end

    elsif pegs[:black] == 1 && pegs[:white] == 2
      positions = [[0,1],[1,2],[2,3],[0,1],[1,2],[2,3]]
      for j in 0..3 # the loop is written this way to be able to 'cycle through' all possibilities
        # delete colors in two positions of last attempt
        switch = positions[j+2]
        @choice[switch[0]] = last_attempt[switch[1]]
        @choice[switch[1]] = last_attempt[switch[0]]
        keep = positions[j][0]
        change = positions[j][1]
        @choice[keep] = last_attempt[keep]
        colors = @colors.dup
        colors.each do |x|
          @choice[change] = x
          if !tried_before #if new choice, stop this loop too
            break
          else
            @choice[first] = nil # set a value to nil so the outer loop will keep going
          end
        end
        break if !@choice.include? nil
      end

    elsif pegs[:black] == 1 && pegs[:white] == 1
      # keep one, move another one around
      for pos in 0..3
        indexes = (0..3).to_a
        indexes.delete(pos)
        @choice[pos] = last_attempt[pos] # keep the 'black' color
        rest = []
        for i in indexes
          rest.push(last_attempt[i])
        end
        choices = rest.permutation(3).to_a
        choices.each do |choice|
          for i in 1..3 #should be indexes?
            @choice[i] = choice[i]
            if @choice[i] == last_attempt[i]
              swap = false # no swap yet, so try another part of the permutation
              next
            else
              swap = true
              index = i # store the position of the 'white' color
              color = @choice[i] # store the 'white' color itself
              break
            end
          end
          next if swap == false # if no swap happened, try another permutation
          indexes.delete(index)
          colors = @colors.dup
          colors.delete(color)
          colors.each do |x|
            @choice[indexes[0]] = x
            colors.each do |y|
              @choice[indexes[1]] = y
              break if !tried_before #if new choice, stop inner loop
            end
            break if !tried_before #if new choice, stop this loop too
          end
          if !tried_before
            break
          else
            @choice[pos] = nil # set a value to nil so the outer loop will keep going
          end
        end
        break if !@choice.include? nil
      end


    elsif pegs[:black] == 0
      if pegs[:white] == 4
        choices = last_attempt.permutation(4).to_a
        choices.each do |choice|
          @choice = choice
          for i in 0..3 do
            if @choice[i] == last_attempt[i]
              incomplete_swap = true # not every color is in different position
            end
          end
          next if incomplete_swap
          break if !tried_before
        end

      elsif pegs[:white] == 3
        for pos in 0..3
          indexes = (0..3).to_a
          indexes.delete(pos)
          colors = @colors.dup
          colors.delete(last_attempt[pos]) # don't use this color
          rest = []
          for i in indexes
            rest.push(last_attempt[i]) # list of colors we'll use to permutate
          end
          choices = rest.permutation(3).to_a
          colors.each do |color|
            @choice[pos] = color
            choices.each do |choice|
              for i in indexes
                @choice[i] = choice[i]
                if @choice[i] == last_attempt[i]
                  incomplete_swap = true
                end
              end
              next if incomplete_swap
              break if !tried_before
            end
            if !tried_before
              break
            else
              @choice[pos] = nil
            end
          end
          break if !@choice.include? nil
        end

      elsif pegs[:white] == 2
        positions = [[0,1],[1,2],[2,3],[3,0],[0,1],[1,2]]
        for j in 0..3 # the loop is written this way to be able to 'cycle through' all possibilities
          # delete colors in two positions of last attempt
          switch = positions[j]
          @choice[switch[0]] = last_attempt[switch[1]]
          @choice[switch[1]] = last_attempt[switch[0]]
          change = positions[j+2]
          first = change[0]
          second = change[1]
          colors = @colors.dup
          colors.delete(last_attempt[first])
          colors.delete(last_attempt[second]) # don't use these colors
          colors.each do |x|
            @choice[first] = x
            colors.each do |y|
              @choice[second] = y
              break if !tried_before #if new choice, stop inner loop
            end
            if !tried_before #if new choice, stop this loop too
              break
            else
              @choice[first] = nil # set a value to nil so the outer loop will keep going
            end
          end
          break if !@choice.include? nil
        end

      elsif pegs[:white] == 1
        #move one around, choose the three remaining colors
        for pos in 0..3
          indexes = (0..3).to_a
          indexes.delete(pos) # the color at this position will be the one to move around
          colors = @colors.dup
          for i in indexes
            colors.delete(last_attempt[i]) # delete all other colors from possibilities
          end
          for i in indexes # main loop: move remaining color to a new position and loop over the others
            @choice[i] = last_attempt[pos]
            others = (0..3).to_a
            others.delete(i) # remaining spots to fill in with new colors
            colors.each do |x|
              @choice[others[0]] = x
              colors.each do |y|
                @choice[others[1]] = y
                colors.each do |z|
                  @choice[others[2]] = z
                  break if !tried_before # if new choice, stop the loop
                end
                break if !tried_before
              end
              break if !tried_before
            end
            break if !tried_before
          end
          if !tried_before
            break
          else
            @choice[pos] = nil
          end
          break if !@choice.include? nil
        end

      else # 0 blacks, 0 whites
        # next guess should not contain any of the colors in the last attempt
        last_attempt.each do |color|
          @colors.delete(color)
        end
        @choice = []
        4.times do
          i = rand(@colors.length)
          @choice.push(@colors[i])
        end
      end
    end # end of huge if statement: time to use new choice

    @attempts.push(@choice)
    play(@choice)
  end # end of guess method

end # end of class

board = Board.new
board.start_game
