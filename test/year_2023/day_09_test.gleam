import glacier/should
import gleam/result
import utils
import year_2023/day_09

pub fn part_1_with_example_input_test() {
  day_09.part_1(example_input)
  |> should.equal(114)
}

pub fn part_2_with_example_input_test() {
  day_09.part_2(example_input)
  |> should.equal(2)
}

pub fn full_input_test() {
  utils.read_input(2023, 9)
  |> result.map(fn(input) {
    day_09.part_1(input)
    |> should.equal(1_479_011_877)

    day_09.part_2(input)
    |> should.equal(973)
  })
}

const example_input = "
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"
