This is a Mastermind game ([Wikipedia](https://en.wikipedia.org/wiki/Mastermind_(board_game))) on the command line written in Ruby. You can choose either to try and break a random code set by the game, or you can get an AI to try and guess your code based on your hints.

This project was a big learning experience for me. The human codebreaker version was easy to write. I got completely lost however in trying to write an AI smart enough to break a code. I wrote lines and lines of twisted code (with nested loops and other convolutions) treating separate scenarios for each combination of black and white pegs. My starting point was building up a list of 'tried' codes, instead of narrowing down the possibilities starting from the full list of possible codes.

I finally realized that a computer does not think like a human and trying to make it do so directly will get you in big trouble. I guess I still have a lot to learn about computer science...

So in the end I defined the set S of 1296 possible codes first, and then used the following rule based on each guess: "remove from S any code that would not give the same response if it (the guess) were the code". After that the AI would choose randomly from this narrowing set of possibilities. This makes for an AI that's not completely optimized but it does seem to get it right in about 7 guesses most of the time, sometimes less.

I also absolutely did not want the 'human' codemaker to have to provide the code they created at any point in the program. To me this is more authentic, since it makes it clear that the computer has to 'guess' just like any other player.

Finally, this is the first project where I'm defining my classes in different files for clarity.


From The Odin Project's [curriculum](https://www.theodinproject.com/courses/ruby-programming/lessons/oop)
