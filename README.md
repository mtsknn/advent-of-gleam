# Advent of Gleam

[Advent of Code](https://adventofcode.com/) solutions in [Gleam](https://gleam.run/).

## Why

- Gleam is fun
- [I ran out of Gleam exercises on Exercism](https://exercism.org/profiles/mtsknn/solutions?track_slug=gleam)

## Running locally

1. [Install Gleam](https://gleam.run/getting-started/installing/)
2. Run all tests:
   ```sh
   gleam test
   ```
   Or start watch mode
   (possible thanks to [Glacier](https://github.com/inoas/glacier)):
   ```sh
   gleam test -- --glacier
   ```
   Or run a single day's tests
   (this too is possible thanks to Glacier):
   ```sh
   gleam test -- test/year_2023/day_01_test.gleam
   ```

### About puzzle inputs and tests

The tests use the example inputs from adventofcode.com.

To also use your own puzzle inputs,
create e.g. `test/year_2023/day_01_input.txt` (ignored by Git).
Though note that the test assertions use my personal results
(your results will be different with your own puzzle inputs).

## Solutions

- [**`year_2023/day_01.gleam`**](./src/year_2023/day_01.gleam) × [adventofcode.com/2023/day/1](https://adventofcode.com/2023/day/1)
- [**`year_2023/day_02.gleam`**](./src/year_2023/day_02.gleam) × [adventofcode.com/2023/day/2](https://adventofcode.com/2023/day/2)
- [**`year_2023/day_03.gleam`**](./src/year_2023/day_03.gleam) × [adventofcode.com/2023/day/3](https://adventofcode.com/2023/day/3)
- [**`year_2023/day_04.gleam`**](./src/year_2023/day_04.gleam) × [adventofcode.com/2023/day/4](https://adventofcode.com/2023/day/4)

  Part 2 was silly (i.e. fun),
  and I like how simple my
  [`number_list_to_numbers` function](https://github.com/mtsknn/advent-of-gleam/blob/b283e0c8386fc3794dc8744ec890b38e49bc0acd/src/year_2023/day_04.gleam#L60-L64)
  turned out.

- [**`year_2023/day_05.gleam`**](./src/year_2023/day_05.gleam) × [adventofcode.com/2023/day/5](https://adventofcode.com/2023/day/5)

  Part 2 was tough.

  With my puzzle input,
  there are 1,638,141,121 seed numbers.

  Iterating over the seed numbers one by one would take an eternity.

  I tried to parallelize the iterations with [OTP Tasks](https://hexdocs.pm/gleam_otp/gleam/otp/task.html),
  but that still took too long –
  about 3 minutes on my machine.

  Eventually I realized to iterate over number ranges instead of single numbers.
  Now Part 2 runs in less than 0.02 seconds (on my machine).

  But I'm glad I tried the parallelization route,
  as it made me start learning that OTP stuff
  (using [Benjamin Peinhardt's _Learn OTP w/ Gleam_ repo](https://github.com/bcpeinhardt/learn_otp_with_gleam)).

- [**`year_2023/day_06.gleam`**](./src/year_2023/day_06.gleam) × [adventofcode.com/2023/day/6](https://adventofcode.com/2023/day/6)
- [**`year_2023/day_07.gleam`**](./src/year_2023/day_07.gleam) × [adventofcode.com/2023/day/7](https://adventofcode.com/2023/day/7)

  I'm quite pleased with the approach I came up with:
  calculating the rank of a hand type by counting the number of different cards,
  and calculating the rank of cards by handling the cards as (hexadecimal) numbers.

- [**`year_2023/day_08.gleam`**](./src/year_2023/day_08.gleam) × [adventofcode.com/2023/day/8](https://adventofcode.com/2023/day/8)
- [**`year_2023/day_09.gleam`**](./src/year_2023/day_09.gleam) × [adventofcode.com/2023/day/9](https://adventofcode.com/2023/day/9)
- [**`year_2023/day_10.gleam`**](./src/year_2023/day_10.gleam) × [adventofcode.com/2023/day/10](https://adventofcode.com/2023/day/10)

  Ahh, I love how [_eleganto_](https://www.youtube.com/watch?v=Ywr5E_q8hiM) my solution is.

  Part 2 is impossible (fight me) without specific math knowledge –
  which I didn't have,
  so I had to do some digging.

  At first I tried to loop over all points not on the path
  and check if each point is inside or outside the path.
  Based on [_Point in polygon_ on Wikipedia](https://en.wikipedia.org/wiki/Point_in_polygon),
  I tried a ray casting algorithm.

  Well, it didn't work,
  so I went to [/r/adventofcode](https://old.reddit.com/r/adventofcode/) to look for spoilers.
  I found two curious terms:

  - [_Shoelace formula_ on Wikipedia](https://en.wikipedia.org/wiki/Shoelace_formula)
  - [_Pick's theorem_ on Wikipedia](https://en.wikipedia.org/wiki/Pick%27s_theorem)

  A-ha, so instead of looping over all non-path points,
  I need to treat the path as a polygon,
  and then calculate the polygon's area,
  and then subtract the amount of boundary (non-interior) points from the area...
  who would have thought!

- [**`year_2023/day_11.gleam`**](./src/year_2023/day_11.gleam) × [adventofcode.com/2023/day/11](https://adventofcode.com/2023/day/11)
- [**`year_2023/day_12.gleam`**](./src/year_2023/day_12.gleam) × [adventofcode.com/2023/day/12](https://adventofcode.com/2023/day/12)

  I managed to get Part 1 (with example input + full input) and Part 2 (with only example input)
  to run in about 0.07s (on my machine).

  Then I struggled in Part 2 with full input.

  TL;DR: The secret ingredient I was missing is memoization.

  It was not a new concept to me,
  but implementing memoization in a functional language with immutable data structures
  felt like a mystery.

  And it still feels like it,
  but luckily I found [`rememo`](https://hexdocs.pm/rememo/)
  which implements memoization with ["Erlang Term Storage"](https://www.erlang.org/doc/apps/stdlib/ets.html) (whatever that is)
  and is a breeze to use.

  After adding memoization with `rememo`,
  the run time for Part 2 with full input
  dropped from eternity to about 0.43s.

  Parallelizing the work with [OTP Tasks](https://hexdocs.pm/gleam_otp/gleam/otp/task.html)
  dropped the run time further to about 0.15s.

  Running both parts, with example input + full input,
  takes about 0.18s on my machine.
  Not bad!

  When looking for help,
  I liked [David Brownman's step-by-step explanation for 2023/12](https://advent-of-code.xavd.id/writeups/2023/day/12/).
  Reading that page helped me simplify my code a bit.

  Three interesting alternative approaches that I found
  via the [2023/12 megathread on /r/adventofcode](https://old.reddit.com/r/adventofcode/comments/18ge41g/2023_day_12_solutions/):

  - [Dynamic programming approach in Rust](https://github.com/maneatingape/advent-of-code-rust/blob/main/src/year2023/day12.rs)
  - ["Using DFA (Deterministic Finite Automata) to turn an exponential problem to a linear one"](https://alexoxorn.github.io/posts/aoc-day12-regular_languages/)
  - [Another DFA solution/explanation](https://github.com/clrfl/AdventOfCode2023/blob/master/12/explanation.ipynb)

  I don't understand any of those ("dynamic programming"? "DFA"?),
  but I'm putting these links here for future reference.

- [**`year_2023/day_13.gleam`**](./src/year_2023/day_13.gleam) × [adventofcode.com/2023/day/13](https://adventofcode.com/2023/day/13)

  This felt very easy after day 12. :P

  Runs in 0.022s on my machine,
  so I won't bother optimizing this further.
