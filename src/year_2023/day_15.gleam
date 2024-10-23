import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/regex
import gleam/result
import gleam/string

type Boxes =
  Dict(Int, List(Lens))

type Lens {
  Lens(label: String, focal_length: Int)
}

pub fn part_1(input: String) -> Int {
  input
  |> to_words
  |> list.map(hash_word)
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  let assert Ok(operation) = regex.from_string("[=-]")

  input
  |> to_words
  |> list.fold(dict.new(), fn(boxes, word) {
    let assert [label, focal_length] = word |> regex.split(with: operation)

    let box_number = label |> hash_word

    case focal_length |> int.parse {
      Ok(focal_length) -> {
        let lens = Lens(label:, focal_length:)
        boxes |> upsert(lens, to: box_number)
      }
      Error(Nil) -> {
        boxes |> remove(label, from: box_number)
      }
    }
  })
  |> dict.fold(0, fn(sum, box_number, lenses) {
    let focusing_power =
      lenses
      |> list.index_map(fn(lens, index) {
        { box_number + 1 } * { index + 1 } * lens.focal_length
      })
      |> int.sum

    sum + focusing_power
  })
}

fn to_words(input: String) -> List(String) {
  input
  |> string.trim
  |> string.split(",")
}

fn hash_word(word: String) -> Int {
  word
  |> string.to_graphemes
  |> list.fold(0, fn(hash_value, char) {
    let assert [utf_codepoint] = char |> string.to_utf_codepoints
    let ascii_code = utf_codepoint |> string.utf_codepoint_to_int
    { hash_value + ascii_code } * 17 % 256
  })
}

fn upsert(boxes: Boxes, lens: Lens, to box_number: Int) -> Boxes {
  boxes
  |> dict.upsert(box_number, fn(lenses) {
    case lenses {
      None -> [lens]
      Some(lenses) ->
        lenses
        |> update(lens, acc: [])
        |> result.unwrap(list.append(lenses, [lens]))
    }
  })
}

fn update(
  lenses: List(Lens),
  lens: Lens,
  acc acc: List(Lens),
) -> Result(List(Lens), Nil) {
  case lenses {
    [] -> Error(Nil)
    [Lens(label, ..), ..rest] if label == lens.label ->
      Ok(list.append(acc |> list.reverse, [lens, ..rest]))
    [first, ..rest] -> update(rest, lens, [first, ..acc])
  }
}

fn remove(boxes: Boxes, label: String, from box_number: Int) -> Boxes {
  boxes
  |> dict.upsert(box_number, fn(lenses) {
    case lenses {
      None -> []
      Some(lenses) -> lenses |> list.filter(fn(lens) { lens.label != label })
    }
  })
}
