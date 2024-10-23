import glacier/should
import gleam/result
import utils
import year_2023/day_14

pub fn part_1_with_example_input_test() {
  day_14.part_1(example_input)
  |> should.equal(136)
}

pub fn part_2_with_example_input_test() {
  day_14.part_2(example_input)
  |> should.equal(64)
}

pub fn full_input_test() {
  utils.read_input(2023, 14)
  |> result.map(fn(input) {
    day_14.part_1(input)
    |> should.equal(113_456)

    day_14.part_2(input)
    |> should.equal(118_747)
  })
}

const example_input = "
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"
