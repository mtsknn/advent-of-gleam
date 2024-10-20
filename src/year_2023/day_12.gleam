import gleam/int
import gleam/list
import gleam/otp/task
import gleam/regex
import gleam/string
import rememo/ets/memo

const task_timeout = 100

type Spring {
  Damaged
  Operational
  Unknown
}

pub fn part_1(input: String) -> Int {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(row) {
    let assert [raw_springs, raw_damaged_groups] =
      row
      |> string.split(" ")

    let springs =
      raw_springs
      |> string.to_graphemes
      |> list.map(fn(spring) {
        case spring {
          "#" -> Damaged
          "." -> Operational
          ___ -> Unknown
        }
      })

    let damaged_groups =
      raw_damaged_groups
      |> string.split(",")
      |> list.filter_map(int.parse)

    task.async(fn() {
      use cache <- memo.create()
      iterate(springs, damaged_groups, cache)
    })
  })
  |> list.map(task.await(_, task_timeout))
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  let regex_options = regex.Options(case_insensitive: True, multi_line: True)
  let assert Ok(line) = regex.compile("^([^ ]+) ([^ ]+)$", with: regex_options)

  input
  |> string.trim
  |> regex.replace(each: line, with: "\\1?\\1?\\1?\\1?\\1 \\2,\\2,\\2,\\2,\\2")
  |> part_1
}

fn iterate(springs: List(Spring), damaged_groups: List(Int), cache) -> Int {
  use <- memo.memoize(#(springs, damaged_groups), with: cache)

  case springs, damaged_groups {
    [], [] -> 1
    [], [_, ..] -> 0

    [Damaged, ..], [] -> 0
    [Damaged, ..], [group_size, ..next_groups] -> {
      let #(group, next_springs) = springs |> list.split(at: group_size)
      case
        group |> list.length == group_size
        && !{ group |> list.any(fn(spring) { spring == Operational }) }
        && next_springs |> list.first != Ok(Damaged)
      {
        True -> iterate(next_springs |> list.drop(1), next_groups, cache)
        False -> 0
      }
    }

    [Operational, ..next_springs], _ ->
      iterate(next_springs, damaged_groups, cache)

    [Unknown, ..next_springs], [] ->
      iterate(next_springs, damaged_groups, cache)
    [Unknown, ..next_springs], [_, ..] ->
      iterate([Damaged, ..next_springs], damaged_groups, cache)
      + iterate(next_springs, damaged_groups, cache)
  }
}
