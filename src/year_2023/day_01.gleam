import gleam/int
import gleam/list
import gleam/regex.{Match}
import gleam/result
import gleam/string

pub fn part_1(input: String) -> Int {
  input
  |> string.trim
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    let chars = line |> string.to_graphemes
    let first = chars |> find_first_number
    let last = chars |> list.reverse |> find_first_number
    join_ok_ints(first, last)
  })
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  let letters = "one|two|three|four|five|six|seven|eight|nine"
  let assert Ok(re1) = regex.from_string("\\d|" <> letters)
  let assert Ok(re2) = regex.from_string("\\d|" <> letters |> string.reverse)

  input
  |> string.trim
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    case regex.scan(re1, line), regex.scan(re2, line |> string.reverse) {
      [Match(content: first, ..), ..], [Match(content: last, ..), ..] -> {
        let first = word_to_int(first)
        let last = word_to_int(last |> string.reverse)
        join_ok_ints(first, last)
      }
      _, _ -> Error(Nil)
    }
  })
  |> int.sum
}

fn find_first_number(chars: List(String)) -> Result(Int, Nil) {
  chars
  |> list.find(fn(char) {
    case char {
      "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
      _ -> False
    }
  })
  |> result.try(int.parse)
}

fn word_to_int(word: String) -> Result(Int, Nil) {
  case word {
    "one" -> Ok(1)
    "two" -> Ok(2)
    "three" -> Ok(3)
    "four" -> Ok(4)
    "five" -> Ok(5)
    "six" -> Ok(6)
    "seven" -> Ok(7)
    "eight" -> Ok(8)
    "nine" -> Ok(9)
    _ -> int.parse(word)
  }
}

fn join_ok_ints(
  left: Result(Int, Nil),
  right: Result(Int, Nil),
) -> Result(Int, Nil) {
  case left, right {
    Ok(left), Ok(right) -> [left, right] |> int.undigits(10)
    _, _ -> Error(Nil)
  }
}
