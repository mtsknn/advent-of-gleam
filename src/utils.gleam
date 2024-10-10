import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub fn log_example_results(results: #(a, b)) -> Nil {
  io.print("Part 1 result w/ example input: ")
  io.debug(results.0)

  io.print("Part 2 result w/ example input: ")
  io.debug(results.1)

  Nil
}

pub fn log_full_results(results: #(a, b)) -> Nil {
  io.print("Part 1 result w/ full input: ")
  io.debug(results.0)

  io.print("Part 2 result w/ full input: ")
  io.debug(results.1)

  Nil
}

pub fn read_input(year: Int, day: Int) -> Result(String, Nil) {
  let year = int.to_string(year)
  let day = int.to_string(day) |> string.pad_left(to: 2, with: "0")
  let filepath = "./src/year_" <> year <> "/day_" <> day <> "_input.txt"

  simplifile.read(filepath)
  |> result.map_error(fn(_) {
    io.println("Note: " <> filepath <> " not found")
    Nil
  })
}
