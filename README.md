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

- [`year_2023/day_01.gleam`](./src/year_2023/day_01.gleam) × [adventofcode.com/2023/day/1](https://adventofcode.com/2023/day/1)
- [`year_2023/day_02.gleam`](./src/year_2023/day_02.gleam) × [adventofcode.com/2023/day/2](https://adventofcode.com/2023/day/2)
- [`year_2023/day_03.gleam`](./src/year_2023/day_03.gleam) × [adventofcode.com/2023/day/3](https://adventofcode.com/2023/day/3)
- [`year_2023/day_04.gleam`](./src/year_2023/day_04.gleam) × [adventofcode.com/2023/day/4](https://adventofcode.com/2023/day/4)
  - Part 2 was silly (i.e. fun),
    and I like how simple my `number_list_to_numbers` function turned out.
- [`year_2023/day_05.gleam`](./src/year_2023/day_05.gleam) × [adventofcode.com/2023/day/5](https://adventofcode.com/2023/day/5)

  - Part 2 was tough.

    With my puzzle input,
    there are 1,638,141,121 seed numbers.

    Iterating over the seed numbers one by one would take an eternity.

    I tried to parallelize the iterations with [OTP Tasks](https://github.com/gleam-lang/otp),
    but that still took too long –
    about 3 minutes on my machine.

    Eventually I realized to iterate over number ranges instead of single numbers.
    Now Part 2 runs in less than 0.02 seconds (on my machine).

    But I'm glad I tried the parallelization route,
    as it made me start learning that OTP stuff
    (using [Benjamin Peinhardt's _Learn OTP w/ Gleam_ repo](https://github.com/bcpeinhardt/learn_otp_with_gleam)).
