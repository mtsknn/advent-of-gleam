import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Coord {
  Coord(x: Int, y: Int)
}

type Direction {
  N
  E
  S
  W
}

type Map =
  Dict(Coord, String)

pub fn part_1(input: String) -> Int {
  let path = input |> find_path

  list.length(path) / 2
}

pub fn part_2(input: String) -> Int {
  let path = input |> find_path

  count_points(inside: path)
}

fn find_path(input: String) -> List(Coord) {
  let map =
    input
    |> string.trim
    |> string.split("\n")
    |> list.index_map(fn(row, y) {
      row
      |> string.to_graphemes
      |> list.index_map(fn(value, x) {
        let coord = Coord(x:, y:)
        #(coord, value)
      })
    })
    |> list.flatten
    |> dict.from_list

  let assert Ok(starting_coord) =
    map
    |> dict.keys
    |> list.find(fn(coord) { map |> dict.get(coord) == Ok("S") })

  let assert Ok(path) =
    [N, E, S]
    |> list.find_map(fn(direction) {
      let path = [starting_coord]
      try_walk(from: starting_coord, towards: direction, on: map, along: path)
    })

  path
}

fn try_walk(
  from current_coord: Coord,
  towards direction: Direction,
  on map: Map,
  along path: List(Coord),
) -> Result(List(Coord), Nil) {
  let next_coord = case direction {
    N -> Coord(..current_coord, y: current_coord.y - 1)
    E -> Coord(..current_coord, x: current_coord.x + 1)
    S -> Coord(..current_coord, y: current_coord.y + 1)
    W -> Coord(..current_coord, x: current_coord.x - 1)
  }
  let next_value = map |> dict.get(next_coord) |> result.unwrap(".")

  use <- bool.guard(when: next_value == "S", return: Ok(path))

  let path = [next_coord, ..path]
  case direction, next_value {
    N, "|" -> try_walk(from: next_coord, towards: N, on: map, along: path)
    N, "F" -> try_walk(from: next_coord, towards: E, on: map, along: path)
    N, "7" -> try_walk(from: next_coord, towards: W, on: map, along: path)

    E, "J" -> try_walk(from: next_coord, towards: N, on: map, along: path)
    E, "-" -> try_walk(from: next_coord, towards: E, on: map, along: path)
    E, "7" -> try_walk(from: next_coord, towards: S, on: map, along: path)

    S, "L" -> try_walk(from: next_coord, towards: E, on: map, along: path)
    S, "|" -> try_walk(from: next_coord, towards: S, on: map, along: path)
    S, "J" -> try_walk(from: next_coord, towards: W, on: map, along: path)

    W, "F" -> try_walk(from: next_coord, towards: S, on: map, along: path)
    W, "-" -> try_walk(from: next_coord, towards: W, on: map, along: path)
    W, "L" -> try_walk(from: next_coord, towards: N, on: map, along: path)

    _, ___ -> Error(Nil)
  }
}

/// Using Pick's theorem: https://en.wikipedia.org/wiki/Pick%27s_theorem
fn count_points(inside path: List(Coord)) -> Int {
  let area = calculate_polygon_area(of: path)

  let boundary_points = list.length(path)
  let interior_points = area - boundary_points / 2 + 1

  interior_points
}

/// Using the Shoelace formula: https://en.wikipedia.org/wiki/Shoelace_formula
fn calculate_polygon_area(of path_coords: List(Coord)) -> Int {
  let assert Ok(first_coord) = path_coords |> list.first

  list.append(path_coords, [first_coord])
  |> list.window_by_2
  |> list.map(fn(corner_pair) {
    let #(Coord(x: x1, y: y1), Coord(x: x2, y: y2)) = corner_pair
    x1 * y2 - x2 * y1
  })
  |> int.sum
  |> fn(sum) { sum / 2 }
  |> int.absolute_value
}
