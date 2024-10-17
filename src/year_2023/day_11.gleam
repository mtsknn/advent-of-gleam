import gleam/int
import gleam/list
import gleam/result
import gleam/string

const rows_to_cols = list.transpose

// This could be simplified to just call `part_2` with `expansion_factor: 2`,
// but I'm keeping this naiver approach because why not
pub fn part_1(input: String) -> Int {
  input
  |> input_to_rows
  |> expand_empty_rows
  |> rows_to_cols
  |> expand_empty_rows
  |> list.index_map(fn(col, x) {
    col
    |> list.index_map(fn(char, y) {
      case char {
        "." -> Error(Nil)
        ___ -> Ok(#(x, y))
      }
    })
  })
  |> list.flatten
  |> result.values
  |> distances
}

pub fn part_2(input: String, expansion_factor expansion_factor: Int) -> Int {
  let rows = input |> input_to_rows
  let row_indexes = rows |> indexes(expansion_factor:)

  let cols = rows |> list.transpose
  let col_indexes = cols |> indexes(expansion_factor:)

  list.map2(rows, row_indexes, fn(row, y) {
    list.map2(row, col_indexes, fn(char, x) {
      case char {
        "." -> Error(Nil)
        ___ -> Ok(#(x, y))
      }
    })
  })
  |> list.flatten
  |> result.values
  |> distances
}

fn input_to_rows(input: String) -> List(List(String)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(string.to_graphemes)
}

fn expand_empty_rows(rows: List(List(String))) {
  rows
  |> list.flat_map(fn(row) {
    case row |> is_empty {
      True -> [row, row]
      False -> [row]
    }
  })
}

fn is_empty(row: List(String)) -> Bool {
  row |> list.all(fn(char) { char == "." })
}

fn distances(coords: List(#(Int, Int))) -> Int {
  coords
  |> list.combination_pairs
  |> list.map(fn(pair) {
    let #(#(x1, y1), #(x2, y2)) = pair
    int.absolute_value(y1 - y2) + int.absolute_value(x1 - x2)
  })
  |> int.sum
}

fn indexes(
  rows: List(List(String)),
  expansion_factor expansion_factor: Int,
) -> List(Int) {
  rows
  |> list.scan(0, fn(index, row) {
    case row |> is_empty {
      True -> index + expansion_factor
      False -> index + 1
    }
  })
}
