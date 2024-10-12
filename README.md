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
create e.g. `src/year_2023/day_01_input.txt` (ignored by Git).
Though note that the test assertions use my personal results
(your results will be different with your own puzzle inputs).

## Solutions

- [`year_2023/day_01.gleam`](./src/year_2023/day_01.gleam) × [adventofcode.com/2023/day/1](https://adventofcode.com/2023/day/1)
- [`year_2023/day_02.gleam`](./src/year_2023/day_02.gleam) × [adventofcode.com/2023/day/2](https://adventofcode.com/2023/day/2)
- [`year_2023/day_03.gleam`](./src/year_2023/day_03.gleam) × [adventofcode.com/2023/day/3](https://adventofcode.com/2023/day/3)
- [`year_2023/day_04.gleam`](./src/year_2023/day_04.gleam) × [adventofcode.com/2023/day/4](https://adventofcode.com/2023/day/4)
  - Part 2 was silly (i.e. fun),
    and I like how simple my `number_list_to_numbers` function turned out.
