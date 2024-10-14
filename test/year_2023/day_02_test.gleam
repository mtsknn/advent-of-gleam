import glacier/should
import gleam/result
import utils
import year_2023/day_02

pub fn part_1_with_example_input_test() {
  day_02.part_1(example_input)
  |> should.equal(8)
}

pub fn part_2_with_example_input_test() {
  day_02.part_2(example_input)
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

const example_input = "
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"
