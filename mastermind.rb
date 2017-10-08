require_relative 'AI'
require_relative 'human'

class Game
  def initialize
    @colors = ["red","green","yellow","blue","orange","purple"]
  end

  def start_game
    puts "Let's play Mastermind!"
    puts "Here's how the game goes:"
    puts "A code consists of four colors."
    puts "The codemaker can choose from six colors to make up his code: #{@colors.join(', ')}."
    puts "Duplicates are allowed, blanks aren't."
    puts "The codebreaker has twelve guesses to figure out this code."
    puts "After a guess, he receives black or white pegs."
    puts "Black means there's a correct color in the right place; white means there's a correct color somewhere but it's in the wrong place."
    puts "Would you like to be the codemaker (1) or codebreaker (2)?"
    role = gets.chomp
    while true
      if role == "1"
        puts "You chose to make the code and see if the computer can break it..."
        @codemaker = Human.new
        @codebreaker = AI.new
        break
      elsif role == "2"
        puts "You chose to try and break the code!"
        @codemaker = AI.new
        @codebreaker = Human.new
        break
      else
        puts "Not a valid choice. Try again"
        role = gets.chomp
      end
    end
    @codemaker.create_code
    play
  end

  def play
    guess = @codebreaker.guess
    pegs = @codemaker.check_code(guess)
    next_try(pegs,guess)
  end

  def next_try(pegs,guess)
    if pegs[:black] == 4
      @codebreaker.won_game
      puts "This was the code: #{guess.join(" ")}"
      exit
    elsif @codebreaker.tries == 12
      @codebreaker.lost_game
      # next lines only executed when AI is codemaker
      puts "This was the code: #{@codemaker.code.join(" ")}"
      exit
    else
      @codebreaker.receive_result(pegs,guess)
      play
    end
  end
end

Game.new.start_game
