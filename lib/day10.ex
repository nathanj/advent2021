defmodule Day10 do
  @moduledoc """
  Day10

  ## Examples


      iex> data = """
      ...> [({(<(())[]>[[{[]{<()<>>
      ...> [(()[<>])]({[<{<<[]>>(
      ...> {([(<{}[<>[]}>{[]{[(<()>
      ...> (((({<>}<{<{<>}{[]{[]{}
      ...> [[<[([]))<([[{}[[()]]]
      ...> [{[{({}]{}}([{[{{{}}([]
      ...> {<[[]]>}<{[{[{[]{()[[[]
      ...> [<(<(<(<{}))><([]([]()
      ...> <{([([[(<>()){}]>(<<{{
      ...> <{([{{}}[<[[[<>{}]]]>[]]
      ...> """
      iex> Day10.pt1(data)
      26397
      iex> Day10.pt2(data)
      288957
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day10.txt"))
  end

  def doit(data) do
    Advent2021.print("day 10 part 1", :timer.tc(Day10, :pt1, [data]))
    Advent2021.print("day 10 part 2", :timer.tc(Day10, :pt2, [data]))
  end

  defp parse(data) do
    data
    |> String.split("\n", trim: true)
  end

  defp reverse_char(ch) do
    cond do
      ch == "}" -> "{"
      ch == ">" -> "<"
      ch == "]" -> "["
      ch == ")" -> "("
    end
  end

  defp compute_line(str) do
      str
      |> String.graphemes()
      |> Enum.reduce_while([], fn ch, stack ->
        if ch == "}" or ch == "]" or ch == ">" or ch == ")" do
          {ch2, stack} = List.pop_at(stack, 0)

          if reverse_char(ch) == ch2 do
            {:cont, stack}
          else
            {:halt, ch}
          end
        else
          {:cont, [ch | stack]}
        end
      end)
  end

  defp score_corrupt_char(ch) do
    cond do
      ch == ")" -> 3
      ch == "]" -> 57
      ch == "}" -> 1197
      ch == ">" -> 25137
    end
  end

  defp score_incomplete_char(ch) do
    cond do
      ch == "(" -> 1
      ch == "[" -> 2
      ch == "{" -> 3
      ch == "<" -> 4
    end
  end

  defp score_incomplete_line(line) do
    Enum.reduce(line, 0, fn x, acc ->
      acc * 5 + score_incomplete_char(x)
    end)
  end

  defp middle_elem(data) do
    Enum.at(data, div(length(data), 2))
  end

  def pt1(data) do
    parse(data)
    |> Enum.map(&compute_line/1)
    |> Enum.reject(&is_list/1)
    |> Enum.map(&score_corrupt_char/1)
    |> Enum.sum()
  end

  def pt2(data) do
    parse(data)
    |> Enum.map(&compute_line/1)
    |> Enum.filter(&is_list/1)
    |> Enum.map(&score_incomplete_line/1)
    |> Enum.sort
    |> middle_elem
  end
end
