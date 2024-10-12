import gleam/result
import gleeunit/should
import utils
import year_2023/day_02

pub fn part_1_with_example_input_test() {
  day_02.part_1(day_02.example_input)
  |> should.equal(8)
}

pub fn part_2_with_example_input_test() {
  day_02.part_2(day_02.example_input)
  |> should.equal(2286)
}

pub fn full_input_test() {
  utils.read_input(2023, 2)
  |> result.map(fn(input) {
    day_02.part_1(input)
    |> should.equal(2685)

    day_02.part_2(input)
    |> should.equal(83_707)
  })
}
