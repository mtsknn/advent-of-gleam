import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/string

type Hand {
  Hand(hand_type_rank: Int, cards_rank: Int, bid: Int)
}

pub fn part_1(input: String) -> Int {
  input
  |> parse_input
  |> list.map(fn(pair) {
    let #(hand, bid) = pair

    Hand(
      hand_type_rank: hand |> rank_hand_type,
      cards_rank: hand |> rank_cards,
      bid:,
    )
  })
  |> calculate_total_bids
}

pub fn part_2(input: String) -> Int {
  input
  |> parse_input
  |> list.map(fn(pair) {
    let #(hand, bid) = pair

    Hand(
      hand_type_rank: hand |> rank_hand_type_with_jokers,
      cards_rank: hand |> string.replace(each: "J", with: "1") |> rank_cards,
      bid:,
    )
  })
  |> calculate_total_bids
}

/// Returns `List(#(hand, bid))`
fn parse_input(input: String) -> List(#(String, Int)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert [hand, bid] = line |> string.split(" ")
    let assert Ok(bid) = bid |> int.parse

    #(hand, bid)
  })
}

/// High number = high rank
fn rank_hand_type(hand: String) -> Int {
  let card_counts =
    hand
    |> string.to_graphemes
    |> list.fold(dict.new(), fn(counts, card) {
      counts
      |> dict.upsert(card, fn(prev_count) {
        { prev_count |> option.unwrap(0) } + 1
      })
    })
    |> dict.values
    |> list.sort(by: order.reverse(int.compare))

  case card_counts {
    [5] -> 7
    [4, 1] -> 6
    [3, 2] -> 5
    [3, 1, 1] -> 4
    [2, 2, 1] -> 3
    [2, 1, 1, 1] -> 2
    _ -> 1
  }
}

/// High number = high rank
fn rank_hand_type_with_jokers(hand: String) -> Int {
  let normal_rank = hand |> rank_hand_type

  let other_cards =
    hand
    |> string.to_graphemes
    |> list.unique
    |> list.filter(fn(card) { card != "J" })
  let alternative_ranks =
    other_cards
    |> list.map(fn(card) {
      hand
      |> string.replace(each: "J", with: card)
      |> rank_hand_type
    })

  [normal_rank, ..alternative_ranks]
  |> list.fold(0, int.max)
}

/// High number = high rank
fn rank_cards(hand: String) -> Int {
  let hex =
    hand
    |> string.replace(each: "A", with: "E")
    |> string.replace(each: "K", with: "D")
    |> string.replace(each: "Q", with: "C")
    |> string.replace(each: "J", with: "B")
    |> string.replace(each: "T", with: "A")

  let assert Ok(rank) = int.base_parse(hex, 16)
  rank
}

fn calculate_total_bids(hands: List(Hand)) -> Int {
  hands
  |> list.sort(fn(a, b) {
    int.compare(a.hand_type_rank, b.hand_type_rank)
    |> order.break_tie(int.compare(a.cards_rank, b.cards_rank))
  })
  |> list.index_map(fn(hand, index) { hand.bid * { index + 1 } })
  |> int.sum
}
