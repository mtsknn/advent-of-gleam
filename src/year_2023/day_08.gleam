import gleam/dict.{type Dict}
import gleam/iterator.{type Iterator}
import gleam/list
import gleam/pair
import gleam/string

type Node {
  Node(left: String, right: String)
}

pub fn part_1(input: String) -> Int {
  let #(directions, nodes) = input |> parse_input

  calculate_steps(
    from: "AAA",
    until: fn(next_label) { next_label == "ZZZ" },
    following: directions,
    and: nodes,
  )
}

pub fn part_2(input: String) -> Int {
  let #(directions, nodes) = input |> parse_input

  let starting_labels =
    nodes
    |> dict.keys
    |> list.filter(fn(label) { label |> string.ends_with("A") })

  // Feels bold to assume that each starting label has only one valid ending label,
  // but works at least with my puzzle input, so :shrug:
  let steps =
    starting_labels
    |> list.map(fn(starting_label) {
      calculate_steps(
        from: starting_label,
        until: fn(next_label) { next_label |> string.ends_with("Z") },
        following: directions,
        and: nodes,
      )
    })

  least_common_multiple(of: steps)
}

fn parse_input(input: String) -> #(Iterator(String), Dict(String, Node)) {
  let assert [directions, nodes] =
    input
    |> string.trim
    |> string.split("\n\n")

  let directions =
    directions
    |> string.to_graphemes
    |> iterator.from_list
    |> iterator.cycle

  let nodes =
    nodes
    |> string.replace(each: " = (", with: ", ")
    |> string.replace(each: ")", with: "")
    |> string.split("\n")
    |> list.fold(dict.new(), fn(nodes, line) {
      let assert [label, left, right] = line |> string.split(", ")

      nodes |> dict.insert(label, Node(left:, right:))
    })

  #(directions, nodes)
}

fn calculate_steps(
  from starting_label: String,
  until is_end_label: fn(String) -> Bool,
  following directions: Iterator(String),
  and nodes: Dict(String, Node),
) -> Int {
  directions
  |> iterator.fold_until(from: #(starting_label, 0), with: fn(acc, direction) {
    let #(label, steps_taken) = acc

    let assert Ok(node) = dict.get(nodes, label)
    let next_label = case direction {
      "L" -> node.left
      ___ -> node.right
    }
    let next_acc = #(next_label, steps_taken + 1)

    case next_label |> is_end_label {
      True -> list.Stop(next_acc)
      False -> list.Continue(next_acc)
    }
  })
  |> pair.second
}

/// Hat tip to https://stackoverflow.com/a/147539/1079869
fn least_common_multiple(of numbers: List(Int)) -> Int {
  numbers |> list.fold(1, lcm)
}

/// Least common multiple
fn lcm(a: Int, b: Int) -> Int {
  a * b / gcd(a, b)
}

/// Greatest common divisor
fn gcd(a: Int, b: Int) -> Int {
  case b {
    0 -> a
    _ -> gcd(b, a % b)
  }
}
