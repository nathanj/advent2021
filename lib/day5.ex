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
    IO.puts("day 5 pt 1: #{pt1(data)}")
    IO.puts("day 5 pt 2: #{pt2(data)}")
  end

  defp parse(line) do
    if match = Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, line) do
      match |> Enum.drop(1) |> Enum.map(&String.to_integer/1) |> Enum.chunk_every(2)
    end
  end

  defp is_horizontal([[x1, _y1], [x2, _y2]]), do: x1 == x2
  defp is_vertical([[_x1, y1], [_x2, y2]]), do: y1 == y2

  defp generate_line_points(line) do
    [[x1, y1], [x2, y2]] = line

    cond do
      is_horizontal(line) ->
        Enum.map(y1..y2, fn y -> [x1, y] end)

      is_vertical(line) ->
        Enum.map(x1..x2, fn x -> [x, y1] end)

      true ->
        dx = if x1 < x2, do: 1, else: -1
        dy = if y1 < y2, do: 1, else: -1
        Enum.map(0..abs(x2 - x1), fn i -> [x1 + i * dx, y1 + i * dy] end)
    end
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
