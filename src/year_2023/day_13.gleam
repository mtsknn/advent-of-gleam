import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_1(input: String) -> Int {
  input
  |> solve(with_one_smudge: False)
}

pub fn part_2(input: String) -> Int {
  input
  |> solve(with_one_smudge: True)
}

fn solve(input: String, with_one_smudge with_one_smudge: Bool) -> Int {
  input
  |> string.trim
  |> string.split("\n\n")
  |> list.map(fn(pattern) {
    let rows = pattern |> string.split("\n")

    rows
    |> find_reflecting_row(with_one_smudge:)
    |> result.map(int.multiply(_, 100))
    |> result.lazy_or(fn() {
      rows
      |> to_cols
      |> find_reflecting_row(with_one_smudge:)
    })
  })
  |> result.values
  |> int.sum
}

fn find_reflecting_row(
  rows: List(String),
  with_one_smudge with_one_smudge: Bool,
) -> Result(Int, Nil) {
  let row_count = list.length(rows)

  list.range(1, row_count - 1)
  |> list.find(fn(n) {
    let #(upper_rows, lower_rows) =
      rows
      |> list.split(at: n)
      |> fn(pair) {
        let #(upper_rows, lower_rows) = pair

        let amount = int.min(n, row_count - n)
        let upper_rows = upper_rows |> list.reverse |> list.take(amount)
        let lower_rows = lower_rows |> list.take(amount)

        #(upper_rows, lower_rows)
      }

    case with_one_smudge {
      True -> list.map2(upper_rows, lower_rows, count_row_diffs) |> int.sum == 1
      False -> upper_rows == lower_rows
    }
  })
}

fn count_row_diffs(row_a: String, row_b: String) -> Int {
  case row_a, row_b {
    "", "" -> 0

    "#" <> row_a, "#" <> row_b -> count_row_diffs(row_a, row_b)
    "." <> row_a, "." <> row_b -> count_row_diffs(row_a, row_b)

    "#" <> row_a, "." <> row_b -> count_row_diffs(row_a, row_b) + 1
    "." <> row_a, "#" <> row_b -> count_row_diffs(row_a, row_b) + 1

    _, _ -> panic
  }
}

fn to_cols(rows: List(String)) -> List(String) {
  rows
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(string.concat)
}
