import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/set
import gleam/string

pub fn part_1(input: String) -> Int {
  let matching_numbers = count_matching_numbers(input)

  matching_numbers
  |> list.fold(0, fn(sum, count) {
    case count {
      0 -> sum
      n -> sum + int_pow(2, exponent: n - 1)
    }
  })
}

pub fn part_2(input: String) -> Int {
  let matching_numbers = count_matching_numbers(input)

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
    let assert [winning_numbers, elfs_numbers] =
      line
      |> string.split(" | ")
      |> list.map(number_list_to_numbers)
      |> list.map(set.from_list)

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
