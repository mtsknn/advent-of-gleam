import gleam/bool
import gleam/int
import gleam/iterator
import gleam/list
import gleam/string

pub fn part_1(input: String) -> Int {
  input
  |> parse_input
  |> list.map(fn(numbers) {
    numbers
    |> to_diff_sequences
    |> list.filter_map(list.last)
    |> int.sum
  })
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  input
  |> parse_input
  |> list.map(fn(numbers) {
    numbers
    |> to_diff_sequences
    |> list.filter_map(list.first)
    |> list.fold(0, fn(prev_number, number) { number - prev_number })
  })
  |> int.sum
}

fn parse_input(input: String) -> List(List(Int)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.filter_map(int.parse)
  })
}

fn to_diff_sequences(numbers: List(Int)) -> List(List(Int)) {
  iterator.unfold(numbers, fn(prev_numbers) {
    use <- bool.guard(
      when: prev_numbers |> list.all(fn(n) { n == 0 }),
      return: iterator.Done,
    )

    let next_numbers =
      prev_numbers
      |> list.window_by_2
      |> list.map(fn(pair) { pair.1 - pair.0 })

    iterator.Next(prev_numbers, next_numbers)
  })
  |> iterator.to_list
  |> list.reverse
}
