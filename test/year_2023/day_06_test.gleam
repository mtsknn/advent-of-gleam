import glacier/should
import gleam/result
import utils
import year_2023/day_06

pub fn part_1_with_example_input_test() {
  day_06.part_1(example_input)
  |> should.equal(288)
}

pub fn part_2_with_example_input_test() {
  day_06.part_2(example_input)
  |> should.equal(71_503)
}

pub fn full_input_test() {
  utils.read_input(2023, 6)
  |> result.map(fn(input) {
    day_06.part_1(input)
    |> should.equal(1_660_968)

    day_06.part_2(input)
    |> should.equal(26_499_773)
  })
}

const example_input = "
Time:      7  15   30
Distance:  9  40  200
"
