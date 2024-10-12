import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub fn read_input(year: Int, day: Int) -> Result(String, Nil) {
  let year = int.to_string(year)
  let day = int.to_string(day) |> string.pad_left(to: 2, with: "0")
  let filepath = "./src/year_" <> year <> "/day_" <> day <> "_input.txt"

  simplifile.read(filepath)
  |> result.map_error(fn(_) {
    io.println_error("\nNote: " <> filepath <> " not found")
    Nil
  })
}
