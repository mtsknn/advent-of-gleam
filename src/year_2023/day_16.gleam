import gleam/dict.{type Dict}
import gleam/int
import gleam/iterator
import gleam/list
import gleam/otp/task
import gleam/string

type Coord {
  Coord(x: Int, y: Int)
}

type Direction {
  Up
  Right
  Down
  Left
}

type GridItem {
  EmptySpace
  MirrorBackslash
  MirrorSlash
  SplitterHorizontal
  SplitterVertical
}

type Map =
  Dict(Coord, MapItem)

type MapItem {
  MapItem(grid_item: GridItem, directions: List(Direction))
}

pub fn part_1(input: String) -> Int {
  let map = input |> to_map

  walk(on: map, from: Coord(x: -1, y: 0), towards: Right, deferred: [])
}

pub fn part_2(input: String) -> Int {
  let map = input |> to_map

  let rows =
    input
    |> string.trim
    |> string.split("\n")
  let assert Ok(first_row) = list.first(rows)
  let max_x = string.length(first_row) - 1
  let max_y = list.length(rows) - 1

  let walk_async = fn(coord: Coord, direction: Direction) {
    task.async(fn() {
      walk(on: map, from: coord, towards: direction, deferred: [])
    })
  }

  let xs = iterator.range(0, max_x)
  let ys = iterator.range(0, max_y)

  iterator.concat([
    xs |> iterator.map(fn(x) { walk_async(Coord(x:, y: -1), Down) }),
    xs |> iterator.map(fn(x) { walk_async(Coord(x:, y: max_y + 1), Up) }),
    ys |> iterator.map(fn(y) { walk_async(Coord(x: -1, y:), Right) }),
    ys |> iterator.map(fn(y) { walk_async(Coord(x: max_x + 1, y:), Left) }),
  ])
  |> iterator.to_list
  |> list.map(task.await(_, 100))
  |> list.fold(0, int.max)
}

fn to_map(input: String) -> Map {
  input
  |> string.trim
  |> string.split("\n")
  |> list.index_map(fn(row, y) {
    row
    |> string.to_graphemes
    |> list.index_map(fn(char, x) {
      let coord = Coord(x:, y:)
      let grid_item = case char {
        "." -> EmptySpace
        "\\" -> MirrorBackslash
        "/" -> MirrorSlash
        "-" -> SplitterHorizontal
        "|" -> SplitterVertical
        ___ -> panic as "Invalid grid item"
      }
      let map_item = MapItem(grid_item:, directions: [])
      #(coord, map_item)
    })
  })
  |> list.flatten
  |> dict.from_list
}

fn walk(
  on map: Map,
  from coord: Coord,
  towards direction: Direction,
  deferred deferred: List(#(Coord, Direction)),
) -> Int {
  let run_deferred_or_count_steps = fn(map: Map) {
    case deferred {
      [#(coord, direction), ..next_deferred] ->
        walk(on: map, from: coord, towards: direction, deferred: next_deferred)
      [] ->
        map
        |> dict.values
        |> list.count(fn(map_item) { !list.is_empty(map_item.directions) })
    }
  }

  let map_item = map |> dict.get(coord)
  let is_looping = case map_item {
    Error(Nil) -> False
    Ok(map_item) -> map_item.directions |> list.contains(direction)
  }

  case is_looping {
    True -> map |> run_deferred_or_count_steps
    False -> {
      let map = case map_item {
        // No map item means we are entering the map from the edge (just outside the map):
        Error(Nil) -> map

        Ok(map_item) ->
          map
          |> dict.insert(
            coord,
            MapItem(..map_item, directions: [direction, ..map_item.directions]),
          )
      }

      let next_coord = case direction {
        Up -> Coord(x: coord.x, y: coord.y - 1)
        Right -> Coord(x: coord.x + 1, y: coord.y)
        Down -> Coord(x: coord.x, y: coord.y + 1)
        Left -> Coord(x: coord.x - 1, y: coord.y)
      }

      case map |> dict.get(next_coord) {
        Error(Nil) -> map |> run_deferred_or_count_steps
        Ok(MapItem(grid_item:, ..)) ->
          case grid_item, direction {
            EmptySpace, _
            | SplitterHorizontal, Right
            | SplitterHorizontal, Left
            | SplitterVertical, Up
            | SplitterVertical, Down
            -> walk(on: map, from: next_coord, towards: direction, deferred:)

            MirrorBackslash, Up | MirrorSlash, Down ->
              walk(on: map, from: next_coord, towards: Left, deferred:)
            MirrorBackslash, Right | MirrorSlash, Left ->
              walk(on: map, from: next_coord, towards: Down, deferred:)
            MirrorBackslash, Down | MirrorSlash, Up ->
              walk(on: map, from: next_coord, towards: Right, deferred:)
            MirrorBackslash, Left | MirrorSlash, Right ->
              walk(on: map, from: next_coord, towards: Up, deferred:)

            SplitterHorizontal, Up | SplitterHorizontal, Down -> {
              let deferred = [#(next_coord, Right), ..deferred]
              walk(on: map, from: next_coord, towards: Left, deferred:)
            }

            SplitterVertical, Right | SplitterVertical, Left -> {
              let deferred = [#(next_coord, Up), ..deferred]
              walk(on: map, from: next_coord, towards: Down, deferred:)
            }
          }
      }
    }
  }
}
