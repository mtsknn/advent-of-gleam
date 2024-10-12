import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regex.{Match}
import gleam/result
import gleam/string

pub const example_input = "
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"

type Color =
  String

type MaxCubeAmounts =
  Dict(Color, Int)

pub fn part_1(input: String) -> Int {
  let max_cube_amounts = parse_input(input)

  max_cube_amounts
  |> list.index_fold(0, fn(sum, cube_amounts, index) {
    let game_number = index + 1
    let is_valid_game =
      True
      && cube_amounts |> dict.get("red") |> result.unwrap(0) <= 12
      && cube_amounts |> dict.get("green") |> result.unwrap(0) <= 13
      && cube_amounts |> dict.get("blue") |> result.unwrap(0) <= 14

    case is_valid_game {
      True -> sum + game_number
      False -> sum
    }
  })
}

pub fn part_2(input: String) -> Int {
  let max_cube_amounts = parse_input(input)

  max_cube_amounts
  |> list.fold(0, fn(sum, amounts) {
    sum
    + { amounts |> dict.get("red") |> result.unwrap(0) }
    * { amounts |> dict.get("green") |> result.unwrap(0) }
    * { amounts |> dict.get("blue") |> result.unwrap(0) }
  })
}

fn parse_input(input: String) -> List(MaxCubeAmounts) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(game) {
    let assert Ok(re) = regex.from_string("[:;] ")
    let assert [_, ..handfuls] = regex.split(re, game)

    handfuls
    |> list.fold(dict.new(), fn(cube_amounts, handful) {
      let assert Ok(re) = regex.from_string("(\\d+) (red|green|blue)")
      regex.scan(re, handful)
      |> list.fold(cube_amounts, fn(cube_amounts, re_match) {
        let assert Match(submatches: [Some(amount), Some(color)], ..) = re_match
        let assert Ok(amount) = amount |> int.parse

        dict.upsert(cube_amounts, color, fn(prev_amount) {
          int.max(amount, prev_amount |> option.unwrap(0))
        })
      })
    })
  })
}
