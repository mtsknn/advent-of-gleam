import glacier/should
import gleam/result
import utils
import year_2023/day_12

pub fn part_1_with_example_input_test() {
  day_12.part_1(example_input)
  |> should.equal(21)
}

pub fn part_2_with_example_input_test() {
  day_12.part_2(example_input)
  |> should.equal(525_152)
}

pub fn full_input_test() {
  utils.read_input(2023, 12)
  |> result.map(fn(input) {
    day_12.part_1(input)
    |> should.equal(7260)

    day_12.part_2(input)
    |> should.equal(1_909_291_258_644)
  })
}

const example_input = "
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"
