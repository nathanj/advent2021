defmodule Day9 do
  @moduledoc """
  Day9

  ## Examples


      iex> data = """
      ...> 2199943210
      ...> 3987894921
      ...> 9856789892
      ...> 8767896789
      ...> 9899965678
      ...> """
      iex> Day9.pt1(data)
      15
      iex> Day9.pt2(data)
      1134
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day9.txt"))
  end

  def doit(data) do
    Advent2021.print("day 9 part 1", :timer.tc(Day9, :pt1, [data]))
    Advent2021.print("day 9 part 2", :timer.tc(Day9, :pt2, [data]))
  end

  defp parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.to_charlist()
      |> Enum.map(fn c ->
        c - 48
      end)
    end)
  end

  defp add_seen(data) do
    Enum.map(data, fn row ->
      Enum.map(row, fn x ->
        {x, false}
      end)
    end)
  end

  defp get_value(data, i, j) do
    if i < 0 or i >= length(data) or j < 0 or j >= length(List.first(data)) do
      9
    else
      Enum.at(Enum.at(data, i), j)
    end
  end

  defp get_value_seen(data, i, j) do
    if i < 0 or i >= length(data) or j < 0 or j >= length(List.first(data)) do
      {9, true}
    else
      Enum.at(Enum.at(data, i), j)
    end
  end

  defp find_basin_size(data, i, j) do
    {v, seen} = get_value_seen(data, i, j)

    if seen or v >= 9 do
      {data, 0}
    else
      data = List.replace_at(data, i, List.replace_at(Enum.at(data, i), j, {v, true}))
      {data, size_n} = find_basin_size(data, i - 1, j)
      {data, size_s} = find_basin_size(data, i + 1, j)
      {data, size_w} = find_basin_size(data, i, j - 1)
      {data, size_e} = find_basin_size(data, i, j + 1)
      {data, size_n + size_s + size_w + size_e + 1}
    end
  end

  defp is_lowest_point(data, i, j) do
    v = get_value(data, i, j)
    n = get_value(data, i - 1, j)
    s = get_value(data, i + 1, j)
    w = get_value(data, i, j - 1)
    e = get_value(data, i, j + 1)

    v < n and v < s and v < w and v < e
  end

  def pt1(data) do
    data =
      data
      |> parse
    i_range = 0..(length(data) - 1)
    j_range = 0..(length(List.first(data)) - 1)

    Enum.reduce(i_range, [], fn i, points ->
        Enum.reduce(j_range, points, fn j, points ->
          if is_lowest_point(data, i, j) do
            [get_value(data, i, j) + 1 | points]
          else
            points
          end
        end)
    end)
    |> Enum.sum()
  end

  def pt2(data) do
    data =
      data
      |> parse
      |> add_seen
    i_range = 0..(length(data) - 1)
    j_range = 0..(length(List.first(data)) - 1)

    Enum.reduce(i_range, {data, []}, fn i, {data, sizes} ->
        Enum.reduce(j_range, {data, sizes}, fn j, {data, sizes} ->
          {data, size} = find_basin_size(data, i, j)
          {data, [size | sizes]}
        end)
    end)
    |> elem(1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end
end
