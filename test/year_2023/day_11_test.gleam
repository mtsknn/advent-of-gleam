import glacier/should
import gleam/result
import utils
import year_2023/day_11

pub fn part_1_with_example_input_test() {
  day_11.part_1(example_input)
  |> should.equal(374)
}

pub fn part_2_with_example_input_test() {
  // Basically the same as part 1:
  day_11.part_2(example_input, expansion_factor: 2)
  |> should.equal(374)

  day_11.part_2(example_input, expansion_factor: 10)
  |> should.equal(1030)

  day_11.part_2(example_input, expansion_factor: 100)
  |> should.equal(8410)
}

pub fn full_input_test() {
  utils.read_input(2023, 11)
  |> result.map(fn(input) {
    day_11.part_1(input)
    |> should.equal(9_591_768)

    day_11.part_2(input, expansion_factor: 1_000_000)
    |> should.equal(746_962_097_860)
  })
}

const example_input = "
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"
