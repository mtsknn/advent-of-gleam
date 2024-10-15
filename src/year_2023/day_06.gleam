import gleam/int
import gleam/iterator
import gleam/list
import gleam/string

pub fn part_1(input: String) -> Int {
  let assert [total_times, record_distances] =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(line_to_numbers)

  list.zip(total_times, record_distances)
  |> list.map(fn(pair) {
    let #(total_time, record_distance) = pair

    let times_held = iterator.range(0, total_time)
    let times_left = iterator.range(total_time, 0)

    iterator.map2(times_held, times_left, int.multiply)
    |> iterator.filter(fn(distance) { distance > record_distance })
    |> iterator.length
  })
  |> int.product
}

pub fn part_2(input: String) -> Int {
  let assert [total_time, record_distance] =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(line_to_single_number)

  // Minimum viable speed to break the record distance
  //
  // Distances are symmetrical, e.g. `[0, 6, 10, 12, 12, 10, 6, 0]`.
  // Instead of starting iteration from the left and going one by one (like in part 1),
  // let's start from the middle and go towards the ends in larger jumps.
  // This way we can determine a good "starting point" for the one-by-one iteration.
  // This saves time; with my puzzle input and on my machine: 0.42s -> 0.04s.
  let assert Ok(min_time_held) =
    iterator.iterate(2, fn(n) { n + 1 })
    |> iterator.find_map(fn(denominator) {
      let time_held = total_time / denominator
      let time_left = total_time - time_held

      let distance = time_held * time_left

      case distance > record_distance {
        True -> Error(Nil)
        False -> Ok(time_held)
      }
    })

  let times_held = iterator.range(min_time_held, total_time)
  let times_left = iterator.range(total_time - min_time_held, 0)

  // Actual minimum speed to break the record distance
  let assert Ok(min_time_held) =
    iterator.zip(times_held, times_left)
    |> iterator.find_map(fn(pair) {
      let #(time_held, time_left) = pair

      let distance = time_held * time_left

      case distance <= record_distance {
        True -> Error(Nil)
        False -> Ok(time_held)
      }
    })

  // This can be calculated like so because the distances are symmetrical
  let max_time_held = total_time - min_time_held

  // Plus one because of inclusive range
  max_time_held - min_time_held + 1
}

fn line_to_numbers(line: String) -> List(Int) {
  line
  |> string.split(" ")
  |> list.filter_map(int.parse)
}

fn line_to_single_number(line: String) -> Int {
  let assert Ok(number) =
    line
    |> string.drop_left(10)
    |> string.replace(each: " ", with: "")
    |> int.parse

  number
}
