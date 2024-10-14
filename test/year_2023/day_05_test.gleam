import glacier/should
import gleam/result
import utils
import year_2023/day_05.{Range}

pub fn part_1_with_example_input_test() {
  day_05.part_1(example_input)
  |> should.equal(35)
}

pub fn part_2_with_example_input_test() {
  day_05.part_2(example_input)
  |> should.equal(46)
}

pub fn full_input_test() {
  utils.read_input(2023, 5)
  |> result.map(fn(input) {
    day_05.part_1(input)
    |> should.equal(579_439_039)

    day_05.part_2(input)
    |> should.equal(7_873_084)
  })
}

pub fn overlaps_test() {
  // No overlap:

  { Range(from: 1, to: 1) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_false

  // Partly to the left, partly overlapping:

  { Range(from: 1, to: 2) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_true

  { Range(from: 1, to: 3) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_true

  // Partly to the left, partly overlapping, partly to the right:

  { Range(from: 1, to: 4) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_true

  // Partly overlapping, partly to the right:

  { Range(from: 2, to: 4) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_true

  { Range(from: 3, to: 4) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_true

  // No overlap:

  { Range(from: 4, to: 4) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_false

  // Identical ranges (full overlap):

  { Range(from: 2, to: 3) |> day_05.overlaps(with: Range(from: 2, to: 3)) }
  |> should.be_true

  // Overlapping in the middle:

  { Range(from: 2, to: 3) |> day_05.overlaps(with: Range(from: 1, to: 4)) }
  |> should.be_true
}

const example_input = "
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"
