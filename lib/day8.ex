defmodule Day8 do
  @moduledoc """
  Day8

  ## Examples

      iex> data = """
      ...> be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      ...> edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      ...> fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      ...> fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      ...> aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      ...> fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      ...> dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      ...> bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      ...> egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      ...> gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
      ...> """
      iex> Day8.pt1(data)
      26
      iex> Day8.pt2(data)
      61229
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day8.txt"))
  end

  def doit(data) do
    Advent2021.print("day  8 part 1", :timer.tc(Day8, :pt1, [data]))
    Advent2021.print("day  8 part 2", :timer.tc(Day8, :pt2, [data]))
  end

  defp parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, " | ")
      |> Enum.map(fn x -> String.split(x, " ") end)
    end)
  end

  defp count_easy_digits(output) do
    output
    |> Enum.map(&String.length/1)
    |> Enum.count(fn x -> x == 2 or x == 3 or x == 4 or x == 7 end)
  end

  defp find_one(input) do
    input
    |> Enum.filter(fn x -> String.length(x) == 2 end)
    |> List.first()
    |> String.to_charlist()
    |> MapSet.new()
  end

  defp find_four(input) do
    input
    |> Enum.filter(fn x -> String.length(x) == 4 end)
    |> List.first()
    |> String.to_charlist()
    |> MapSet.new()
  end

  defp find_seven(input) do
    input
    |> Enum.filter(fn x -> String.length(x) == 3 end)
    |> List.first()
    |> String.to_charlist()
    |> MapSet.new()
  end

  defp find_three(input, one) do
    input
    |> Enum.filter(fn x -> String.length(x) == 5 end)
    |> Enum.map(fn x -> x |> String.to_charlist() |> MapSet.new() end)
    |> Enum.filter(fn x -> x |> MapSet.intersection(one) |> MapSet.size() == 2 end)
    |> List.first()
  end

  defp find_six(input, one) do
    input
    |> Enum.filter(fn x -> String.length(x) == 6 end)
    |> Enum.map(fn x -> x |> String.to_charlist() |> MapSet.new() end)
    |> Enum.filter(fn x -> x |> MapSet.intersection(one) |> MapSet.size() == 1 end)
    |> List.first()
  end

  def pt1(data) do
    data
    |> parse
    |> Enum.map(fn [_input, output] -> count_easy_digits(output) end)
    |> Enum.sum()
  end

  defp decode(data) do
    [input, output] = data
    one = find_one(input)
    four = find_four(input)
    seven = find_seven(input)
    six = find_six(input, one)
    three = find_three(input, one)

    all_segments = MapSet.new("abcdefg" |> String.to_charlist())
    segment_a = MapSet.difference(seven, one) |> MapSet.to_list() |> List.first()

    segment_g =
      MapSet.difference(three, four)
      |> MapSet.delete(segment_a)
      |> MapSet.to_list()
      |> List.first()

    segment_b = MapSet.difference(four, three) |> MapSet.to_list() |> List.first()
    segment_c = MapSet.difference(one, six) |> MapSet.to_list() |> List.first()

    segment_d =
      MapSet.difference(four, one) |> MapSet.delete(segment_b) |> MapSet.to_list() |> List.first()

    segment_f = MapSet.intersection(six, one) |> MapSet.to_list() |> List.first()

    segment_e =
      MapSet.difference(
        all_segments,
        MapSet.new([segment_a, segment_b, segment_c, segment_d, segment_f, segment_g])
      )
      |> MapSet.to_list()
      |> List.first()

    zero = MapSet.new([segment_a, segment_b, segment_c, segment_e, segment_f, segment_g])
    two = MapSet.new([segment_a, segment_c, segment_d, segment_e, segment_g])
    five = MapSet.new([segment_a, segment_b, segment_d, segment_f, segment_g])
    eight = all_segments
    nine = MapSet.new([segment_a, segment_b, segment_c, segment_d, segment_f, segment_g])

    output
    |> Enum.map(fn x -> x |> String.to_charlist() |> MapSet.new() end)
    |> Enum.map(fn x ->
      cond do
        MapSet.equal?(x, zero) -> 0
        MapSet.equal?(x, one) -> 1
        MapSet.equal?(x, two) -> 2
        MapSet.equal?(x, three) -> 3
        MapSet.equal?(x, four) -> 4
        MapSet.equal?(x, five) -> 5
        MapSet.equal?(x, six) -> 6
        MapSet.equal?(x, seven) -> 7
        MapSet.equal?(x, eight) -> 8
        MapSet.equal?(x, nine) -> 9
      end
    end)
    |> Enum.reduce(0, fn x, acc -> acc * 10 + x end)
  end

  def pt2(data) do
    data
    |> parse
    |> Enum.map(&decode/1)
    |> Enum.sum()
  end
end
