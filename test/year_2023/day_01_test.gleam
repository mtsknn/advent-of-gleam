import glacier/should
import gleam/result
import utils
import year_2023/day_01

pub fn part_1_with_example_input_test() {
  day_01.part_1(day_01.part_1_example_input)
  |> should.equal(142)
}

pub fn part_2_with_example_input_test() {
  day_01.part_2(day_01.part_2_example_input)
  |> should.equal(281)
}

pub fn full_input_test() {
  utils.read_input(2023, 1)
  |> result.map(fn(input) {
    day_01.part_1(input)
    |> should.equal(54_927)

    day_01.part_2(input)
    |> should.equal(54_581)
  })
}
