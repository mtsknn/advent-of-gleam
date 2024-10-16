import glacier/should
import gleam/result
import utils
import year_2023/day_08

pub fn part_1_with_example_input_test() {
  day_08.part_1(part_1_example_input_1)
  |> should.equal(2)

  day_08.part_1(part_1_example_input_2)
  |> should.equal(6)
}

pub fn part_2_with_example_input_test() {
  day_08.part_2(part_2_example_input)
  |> should.equal(6)
}

pub fn full_input_test() {
  utils.read_input(2023, 8)
  |> result.map(fn(input) {
    day_08.part_1(input)
    |> should.equal(19_951)

    day_08.part_2(input)
    |> should.equal(16_342_438_708_751)
  })
}

const part_1_example_input_1 = "
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"

const part_1_example_input_2 = "
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"

const part_2_example_input = "
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"
