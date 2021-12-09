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

  defp add_bounding_box(data) do
    horizontal_padded =
      data
      |> Enum.map(fn x -> [10] ++ x ++ [10] end)

    row_padding =
      horizontal_padded
      |> List.first()
      |> Enum.map(fn _ -> 10 end)

    [row_padding] ++ horizontal_padded ++ [row_padding]
  end

  defp find_basin_size(data, i, j) do
    {v, seen} = Enum.at(Enum.at(data, i), j)

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
    v = Enum.at(Enum.at(data, i), j)
    n = Enum.at(Enum.at(data, i - 1), j)
    s = Enum.at(Enum.at(data, i + 1), j)
    w = Enum.at(Enum.at(data, i), j - 1)
    e = Enum.at(Enum.at(data, i), j + 1)

    v < n and v < s and v < w and v < e
  end

  def pt1(data) do
    data =
      data
      |> parse
      |> add_bounding_box

    Enum.reduce(1..(length(data) - 2), [], fn i, pts ->
        Enum.reduce(1..(length(Enum.at(data, i)) - 2), pts, fn j, pts ->
          v = Enum.at(Enum.at(data, i), j)
          if is_lowest_point(data, i, j), do: [v + 1 | pts], else: pts
        end)
    end)
    |> Enum.sum()
  end

  def pt2(data) do
    data =
      data
      |> parse
      |> add_bounding_box
      |> add_seen

    Enum.reduce(1..(length(data) - 2), {data, []}, fn i, {data, sizes} ->
        Enum.reduce(1..(length(Enum.at(data, i)) - 2), {data, sizes}, fn j, {data, sizes} ->
          {data, v} = find_basin_size(data, i, j)
          {data, [v | sizes]}
        end)
    end)
    |> elem(1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end
end
