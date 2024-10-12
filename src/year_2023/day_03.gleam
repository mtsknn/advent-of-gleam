import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/regex.{Match}
import gleam/result
import gleam/string

pub const example_input = "
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"

type Number {
  Number(x1: Int, x2: Int, y: Int, value: Int)
}

type Symbol {
  Symbol(x: Int, y: Int, value: String)
}

pub fn part_1(input: String) -> Int {
  let numbers = get_numbers(input)
  let symbols = get_symbols(input)

  numbers
  |> list.filter_map(fn(number) {
    let neighbor_coords =
      get_neighbor_coords(x1: number.x1, x2: number.x2, y: number.y)

    let has_any_symbol_neighbors =
      symbols
      |> list.any(fn(symbol) {
        neighbor_coords |> list.contains(#(symbol.x, symbol.y))
      })

    case has_any_symbol_neighbors {
      True -> Ok(number.value)
      False -> Error(Nil)
    }
  })
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  let numbers = get_numbers(input)
  let symbols = get_symbols(input)

  symbols
  |> list.filter(fn(symbol) { symbol.value == "*" })
  |> list.filter_map(fn(gear) {
    let number_neighbors =
      numbers
      |> list.filter_map(fn(number) {
        let is_neighbor =
          True
          && gear.x >= number.x1 - 1
          && gear.x <= number.x2 + 1
          && gear.y >= number.y - 1
          && gear.y <= number.y + 1

        case is_neighbor {
          True -> Ok(number.value)
          False -> Error(Nil)
        }
      })

    case number_neighbors {
      [a, b] -> Ok(a * b)
      _ -> Error(Nil)
    }
  })
  |> int.sum
}

fn get_numbers(schematic: String) -> List(Number) {
  schematic
  |> string.trim
  |> string.split("\n")
  |> list.index_map(fn(row, y) {
    let assert Ok(re) = regex.from_string("([^\\d]*)(\\d+)")
    regex.scan(re, row)
    |> list.map_fold(0, fn(prev_match_length, match) {
      let assert Match(submatches: [prefix, Some(number_string)], ..) = match

      let prefix_length = prefix |> option.unwrap("") |> string.length
      let number_length = number_string |> string.length

      let x1 = prev_match_length + prefix_length
      let x2 = x1 + number_length - 1

      let assert Ok(number_value) =
        number_string
        |> string.to_graphemes
        |> list.filter_map(int.parse)
        |> int.undigits(10)

      let number = Number(x1:, x2:, y:, value: number_value)

      #(prev_match_length + prefix_length + number_length, number)
    })
    |> pair.second
  })
  |> list.flatten
}

fn get_symbols(schematic: String) -> List(Symbol) {
  schematic
  |> string.trim
  |> string.split("\n")
  |> list.index_map(fn(row, y) {
    row
    |> string.to_graphemes
    |> list.index_map(fn(char, x) {
      case char != "." && char |> int.parse |> result.is_error {
        True -> Ok(Symbol(x:, y:, value: char))
        False -> Error(Nil)
      }
    })
    |> result.values
  })
  |> list.flatten
}

/// Returns `List(#(x, y))`
fn get_neighbor_coords(x1 x1: Int, x2 x2: Int, y y: Int) -> List(#(Int, Int)) {
  [
    // Top-left, left and bottom-left:
    #(x1 - 1, y - 1),
    #(x1 - 1, y),
    #(x1 - 1, y + 1),
    // Top-right, right and bottom-right:
    #(x2 + 1, y - 1),
    #(x2 + 1, y),
    #(x2 + 1, y + 1),
    // Ups and downs:
    ..list.range(x1, x2)
    |> list.flat_map(fn(x) { [#(x, y - 1), #(x, y + 1)] })
  ]
}
