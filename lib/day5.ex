defmodule Day5 do
  @moduledoc """
  Day5

  ## Examples

      iex> data = """
      ...> 0,9 -> 5,9
      ...> 8,0 -> 0,8
      ...> 9,4 -> 3,4
      ...> 2,2 -> 2,1
      ...> 7,0 -> 7,4
      ...> 6,4 -> 2,0
      ...> 0,9 -> 2,9
      ...> 3,4 -> 1,4
      ...> 0,0 -> 8,8
      ...> 5,5 -> 8,2
      ...> """
      iex> Day5.pt1(data)
      5
      iex> Day5.pt2(data)
      12
  """

  def doit() do
    doit(File.read!("inputs/day5.txt"))
  end

  def doit(data) do
    Advent2021.print("day 5 part 1", :timer.tc(Day5, :pt1, [data]))
    Advent2021.print("day 5 part 2", :timer.tc(Day5, :pt2, [data]))
  end

  defp parse(line) do
    if match = Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, line) do
      match |> Enum.drop(1) |> Enum.map(&String.to_integer/1) |> Enum.chunk_every(2)
    end
  end

  defp is_horizontal([[x1, _y1], [x2, _y2]]), do: x1 == x2
  defp is_vertical([[_x1, y1], [_x2, y2]]), do: y1 == y2

  defp sign_delta(a, b) do
    cond do
      a == b -> 0
      a > b -> -1
      a < b -> 1
    end
  end

  defp generate_line_points(line) do
    [[x1, y1], [x2, y2]] = line
    dx = sign_delta(x1, x2)
    dy = sign_delta(y1, y2)
    length = max(abs(x2 - x1), abs(y2 - y1))
    Enum.map(0..length, fn i -> [x1 + i * dx, y1 + i * dy] end)
  end

  def pt1(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse/1)
    |> Enum.filter(fn x -> is_horizontal(x) or is_vertical(x) end)
    |> Enum.map(&generate_line_points/1)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.frequencies()
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  def pt2(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&generate_line_points/1)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.frequencies()
    |> Enum.count(fn {_, v} -> v > 1 end)
  end
end
