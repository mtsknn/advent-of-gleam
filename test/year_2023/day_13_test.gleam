import glacier/should
import gleam/result
import utils
import year_2023/day_13

pub fn part_1_with_example_input_test() {
  day_13.part_1(example_input)
  |> should.equal(405)
}

pub fn part_2_with_example_input_test() {
  day_13.part_2(example_input)
  |> should.equal(400)
}

pub fn full_input_test() {
  utils.read_input(2023, 13)
  |> result.map(fn(input) {
    day_13.part_1(input)
    |> should.equal(29_130)

    day_13.part_2(input)
    |> should.equal(33_438)
  })
}

const example_input = "
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"
