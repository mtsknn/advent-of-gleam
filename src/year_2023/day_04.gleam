import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/set
import gleam/string
import utils

const example_input = "
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"

pub fn main() {
  solve(using: example_input)
  |> utils.log_example_results

  utils.read_input(2023, 4)
  |> result.map(fn(input) {
    solve(using: input)
    |> utils.log_full_results
  })
}

fn solve(using input: String) -> #(Int, Int) {
  let matching_numbers = count_matching_numbers(input)

  let result_1 = part_1(matching_numbers)
  let result_2 = part_2(matching_numbers)

  #(result_1, result_2)
}

fn part_1(matching_numbers: List(Int)) -> Int {
  matching_numbers
  |> list.fold(0, fn(sum, count) {
    case count {
      0 -> sum
      n -> sum + int_pow(2, exponent: n - 1)
    }
  })
}

fn part_2(matching_numbers: List(Int)) -> Int {
  matching_numbers
  |> list.index_fold(
    dict.new(),
    fn(card_counts, matching_numbers_count, game_index) {
      let card_counts = card_counts |> dict.upsert(game_index, inc(_, by: 1))

      use <- bool.guard(when: matching_numbers_count == 0, return: card_counts)

      let assert Ok(current_card_count) = card_counts |> dict.get(game_index)

      list.range(game_index + 1, game_index + 1 + matching_numbers_count - 1)
      |> list.fold(card_counts, fn(card_counts, game_index) {
        card_counts |> dict.upsert(game_index, inc(_, by: current_card_count))
      })
    },
  )
  |> dict.values
  |> int.sum
}

fn count_matching_numbers(input: String) -> List(Int) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert Ok(#(left, right)) = line |> string.split_once(" | ")

    let winning_numbers = number_list_to_numbers(left) |> set.from_list
    let elfs_numbers = number_list_to_numbers(right) |> set.from_list

    set.intersection(winning_numbers, elfs_numbers)
    |> set.size
  })
}

fn number_list_to_numbers(list: String) -> List(Int) {
  list
  |> string.split(" ")
  |> list.filter_map(int.parse)
}

fn int_pow(base: Int, exponent exponent: Int) -> Int {
  case exponent {
    0 -> 1
    1 -> base
    _ -> base * int_pow(base, exponent - 1)
  }
}

fn inc(opt: Option(Int), by by: Int) -> Int {
  { opt |> option.unwrap(0) } + by
}
