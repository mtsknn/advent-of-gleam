import glacier/should
import gleam/result
import utils
import year_2023/day_15

pub fn part_1_with_example_input_test() {
  day_15.part_1(example_input)
  |> should.equal(1320)
}

pub fn part_2_with_example_input_test() {
  day_15.part_2(example_input)
  |> should.equal(145)
}

pub fn full_input_test() {
  utils.read_input(2023, 15)
  |> result.map(fn(input) {
    day_15.part_1(input)
    |> should.equal(514_025)

    day_15.part_2(input)
    |> should.equal(244_461)
  })
}

const example_input = "
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
"
