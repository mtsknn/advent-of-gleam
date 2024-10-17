import glacier/should
import gleam/result
import utils
import year_2023/day_10

pub fn part_1_with_example_input_test() {
  day_10.part_1(part_1_example_input_1)
  |> should.equal(4)

  day_10.part_1(part_1_example_input_2)
  |> should.equal(8)
}

pub fn part_2_with_example_input_test() {
  day_10.part_2(part_2_example_input_1)
  |> should.equal(4)

  day_10.part_2(part_2_example_input_2)
  |> should.equal(4)

  day_10.part_2(part_2_example_input_3)
  |> should.equal(8)

  day_10.part_2(part_2_example_input_4)
  |> should.equal(10)
}

pub fn full_input_test() {
  utils.read_input(2023, 10)
  |> result.map(fn(input) {
    day_10.part_1(input)
    |> should.equal(6931)

    day_10.part_2(input)
    |> should.equal(357)
  })
}

const part_1_example_input_1 = "
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
"

const part_1_example_input_2 = "
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
"

const part_2_example_input_1 = "
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"

const part_2_example_input_2 = "
..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
..........
"

const part_2_example_input_3 = "
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"

const part_2_example_input_4 = "
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"
