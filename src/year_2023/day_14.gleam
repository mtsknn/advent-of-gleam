import gleam/dict
import gleam/int
import gleam/iterator
import gleam/list.{Continue, Stop}
import gleam/queue.{type Queue}
import gleam/result
import gleam/string

type Item {
  Boulder
  Rock
  Space
}

/// Flips the platform to its side
/// and handles each column like it were a row
pub fn part_1(input: String) -> Int {
  input
  |> to_rows
  // Flip 90 degrees to the left so that North is on the left:
  |> list.transpose
  |> list.map(fn(col) { roll_rocks_left(on: col, acc: queue.new()) })
  // Flip back, i.e. 90 degrees to the right:
  |> list.transpose
  |> calculate_total_load
}

/// Flips the platform four times per cycle,
/// which is a relatively slow thing to do :(
pub fn part_2(input: String) -> Int {
  let rows = input |> to_rows

  // The cycles start to loop at some point,
  // so no need to actually iterate a billion times
  let #(final_rows, _, _) =
    iterator.range(1, 1_000_000_000)
    |> iterator.fold_until(#(rows, dict.new(), dict.new()), fn(acc, index) {
      let #(rows, rows_to_index, index_to_rows) = acc

      let next_rows =
        rows
        // North:
        |> list.transpose
        |> list.map(fn(col) { roll_rocks_left(on: col, acc: queue.new()) })
        // West:
        |> list.transpose
        |> list.map(fn(row) { roll_rocks_left(on: row, acc: queue.new()) })
        // South:
        |> list.transpose
        |> list.map(fn(col) { roll_rocks_right(on: col, acc: queue.new()) })
        // East:
        |> list.transpose
        |> list.map(fn(row) { roll_rocks_right(on: row, acc: queue.new()) })

      // Check if the cycles started to loop in this cycle:
      case rows_to_index |> dict.get(next_rows) {
        // Yep -> "fast forward" to the billionth cycle:
        Ok(prev_index_with_same_rows) -> {
          let cycles_before_looping_started = prev_index_with_same_rows - 1
          let loop_length = index - prev_index_with_same_rows

          let final_index =
            { 1_000_000_000 - cycles_before_looping_started }
            % loop_length
            + cycles_before_looping_started

          let final_rows =
            index_to_rows
            |> dict.get(final_index)
            |> result.unwrap(next_rows)

          Stop(#(final_rows, rows_to_index, index_to_rows))
        }

        // Nope -> continue iterating:
        Error(Nil) -> {
          let index_to_rows = index_to_rows |> dict.insert(index, next_rows)
          let rows_to_index = rows_to_index |> dict.insert(next_rows, index)

          Continue(#(next_rows, rows_to_index, index_to_rows))
        }
      }
    })

  final_rows
  |> calculate_total_load
}

fn to_rows(input: String) -> List(List(Item)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(row) {
    row
    |> string.to_graphemes
    |> list.map(fn(char) {
      case char {
        "#" -> Boulder
        "O" -> Rock
        ___ -> Space
      }
    })
  })
}

fn roll_rocks_left(on row: List(Item), acc acc: Queue(Item)) -> List(Item) {
  case row {
    [] -> acc |> queue.to_list
    [Boulder, ..rest] ->
      list.append(acc |> queue.to_list, [
        Boulder,
        ..roll_rocks_left(rest, queue.new())
      ])
    [Rock, ..rest] -> roll_rocks_left(rest, acc |> queue.push_front(Rock))
    [Space, ..rest] -> roll_rocks_left(rest, acc |> queue.push_back(Space))
  }
}

fn roll_rocks_right(on row: List(Item), acc acc: Queue(Item)) -> List(Item) {
  case row {
    [] -> acc |> queue.to_list
    [Boulder, ..rest] ->
      list.append(acc |> queue.to_list, [
        Boulder,
        ..roll_rocks_right(rest, queue.new())
      ])
    [Rock, ..rest] -> roll_rocks_right(rest, acc |> queue.push_back(Rock))
    [Space, ..rest] -> roll_rocks_right(rest, acc |> queue.push_front(Space))
  }
}

fn calculate_total_load(rows: List(List(Item))) -> Int {
  let row_count = list.length(rows)

  rows
  |> list.index_map(fn(row, index) {
    let load_per_rock = row_count - index
    let rock_count = row |> list.count(fn(item) { item == Rock })
    load_per_rock * rock_count
  })
  |> int.sum
}
