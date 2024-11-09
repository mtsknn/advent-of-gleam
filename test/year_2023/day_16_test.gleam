import glacier/should
import gleam/result
import utils
import year_2023/day_16

pub fn part_1_with_example_input_test() {
  day_16.part_1(example_input)
  |> should.equal(46)
}

pub fn part_2_with_example_input_test() {
  day_16.part_2(example_input)
  |> should.equal(51)
}

pub fn full_input_test() {
  utils.read_input(2023, 16)
  |> result.map(fn(input) {
    day_16.part_1(input)
    |> should.equal(7034)

    day_16.part_2(input)
    |> should.equal(7759)
  })
}

const example_input = "
.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....
"
