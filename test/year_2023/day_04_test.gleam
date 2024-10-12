import gleam/result
import gleeunit/should
import utils
import year_2023/day_04

pub fn part_1_with_example_input_test() {
  day_04.part_1(day_04.example_input)
  |> should.equal(13)
}

pub fn part_2_with_example_input_test() {
  day_04.part_2(day_04.example_input)
  |> should.equal(30)
}

pub fn full_input_test() {
  utils.read_input(2023, 4)
  |> result.map(fn(input) {
    day_04.part_1(input)
    |> should.equal(20_117)

    day_04.part_2(input)
    |> should.equal(13_768_818)
  })
}
