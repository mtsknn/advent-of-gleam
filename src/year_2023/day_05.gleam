import gleam/int
import gleam/list
import gleam/result
import gleam/string

type MapRow {
  MapRow(range: Range, delta: Int)
}

pub type Range {
  /// Inclusive range: `Range(1, 3)` represents the numbers 1, 2 and 3
  Range(from: Int, to: Int)
}

/// Simple approach: iterate over each number
pub fn part_1(input: String) -> Int {
  let assert Ok(#(seeds, maps)) =
    input
    |> string.trim
    |> string.split_once("\n\n")

  let initial_values = seeds |> line_to_numbers

  let number_mappers =
    maps
    |> string.split("\n\n")
    |> list.map(fn(map) {
      map
      |> string.split("\n")
      |> list.drop(1)
      |> list.map(fn(line) {
        let assert [destination_start, source_start, range_length] =
          line |> line_to_numbers

        fn(number: Int) -> Result(Int, Nil) {
          let delta = number - source_start
          case delta >= 0 && delta < range_length {
            True -> Ok(destination_start + delta)
            False -> Error(Nil)
          }
        }
      })
      |> fn(number_mappers) {
        fn(value: Int) {
          number_mappers
          |> list.find_map(fn(number_mapper) { number_mapper(value) })
          |> result.unwrap(value)
        }
      }
    })

  let final_values =
    initial_values
    |> list.map(fn(value) {
      number_mappers
      |> list.fold(value, fn(value, number_mapper) { number_mapper(value) })
    })

  let assert Ok(min_value) = final_values |> list.reduce(int.min)

  min_value
}

/// More complex approach: iterate over number ranges
pub fn part_2(input: String) -> Int {
  let assert Ok(#(seeds, maps)) =
    input
    |> string.trim
    |> string.split_once("\n\n")

  let initial_ranges =
    seeds
    |> line_to_numbers
    |> list.sized_chunk(2)
    |> list.map(fn(pair) {
      let assert [from, range_length] = pair
      Range(from:, to: from + range_length - 1)
    })

  let maps = {
    use map <- list.map(maps |> string.split("\n\n"))
    use line <- list.map(map |> string.split("\n") |> list.drop(1))

    let assert [destination_start, source_start, range_length] =
      line |> line_to_numbers

    MapRow(
      range: Range(from: source_start, to: source_start + range_length - 1),
      delta: destination_start - source_start,
    )
  }

  let final_ranges = {
    use ranges, map_rows <- list.fold(maps, initial_ranges)

    map_rows
    |> list.map_fold(ranges, fn(ranges, map_row) {
      use ranges, range <- list.fold(ranges, #([], []))

      let #(unmapped_ranges, mapped_ranges) = ranges

      // Leftward portion of the range remains unmapped:
      let unmapped_ranges = case range.from < map_row.range.from {
        True -> [
          Range(from: range.from, to: int.min(range.to, map_row.range.from - 1)),
          ..unmapped_ranges
        ]
        False -> unmapped_ranges
      }

      // Middle (i.e. overlapping) portion of the range gets mapped:
      let mapped_ranges = case range |> overlaps(with: map_row.range) {
        True -> [
          Range(
            from: int.max(range.from, map_row.range.from) + map_row.delta,
            to: int.min(range.to, map_row.range.to) + map_row.delta,
          ),
          ..mapped_ranges
        ]
        False -> mapped_ranges
      }

      // Rightward portion of the range remains unmapped:
      let unmapped_ranges = case range.to > map_row.range.to {
        True -> [
          Range(from: int.max(range.from, map_row.range.to + 1), to: range.to),
          ..unmapped_ranges
        ]
        False -> unmapped_ranges
      }

      #(unmapped_ranges, mapped_ranges)
    })
    |> fn(ranges) {
      let #(unmapped_ranges, mapped_ranges) = ranges
      let mapped_ranges = mapped_ranges |> list.flatten
      list.append(unmapped_ranges, mapped_ranges)
    }
  }

  let assert Ok(min_value) =
    final_ranges
    |> list.map(fn(range) { range.from })
    |> list.reduce(int.min)

  min_value
}

fn line_to_numbers(line: String) -> List(Int) {
  line
  |> string.split(" ")
  |> list.filter_map(int.parse)
}

/// Exported for unit tests
pub fn overlaps(a: Range, with b: Range) -> Bool {
  a.from <= b.to && a.to >= b.from
}
