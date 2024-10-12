import gleam/result
import gleeunit/should
import utils
import year_2023/day_03

pub fn part_1_with_example_input_test() {
  day_03.part_1(day_03.example_input)
  |> should.equal(4361)
}

pub fn part_2_with_example_input_test() {
  day_03.part_2(day_03.example_input)
  |> should.equal(467_835)
}

pub fn full_input_test() {
  utils.read_input(2023, 3)
  |> result.map(fn(input) {
    day_03.part_1(input)
    |> should.equal(539_637)

    day_03.part_2(input)
    |> should.equal(82_818_007)
  })
}
