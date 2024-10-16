import glacier/should
import gleam/result
import utils
import year_2023/day_07

pub fn part_1_with_example_input_test() {
  day_07.part_1(example_input)
  |> should.equal(6440)
}

pub fn part_2_with_example_input_test() {
  day_07.part_2(example_input)
  |> should.equal(5905)
}

pub fn full_input_test() {
  utils.read_input(2023, 7)
  |> result.map(fn(input) {
    day_07.part_1(input)
    |> should.equal(251_927_063)

    day_07.part_2(input)
    |> should.equal(255_632_664)
  })
}

const example_input = "
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"
