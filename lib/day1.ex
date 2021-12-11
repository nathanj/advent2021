defmodule Day1 do
  @moduledoc """
  Day1

  ## Examples

      iex> Day1.pt1([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
      7
      iex> Day1.pt2([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
      5
  """

  def doit() do
    data =
      File.stream!("inputs/day1.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    Advent2021.print("day  1 part 1", :timer.tc(Day1, :pt1, [data]))
    Advent2021.print("day  1 part 2", :timer.tc(Day1, :pt2, [data]))
  end

  def pt1(data) do
    data
    |> Enum.chunk_every(2, 1, :discard)
    # |> IO.inspect(label: "chunked")
    |> Enum.count(fn [a, b] -> b > a end)
  end

  def pt2(data) do
    data
    |> Enum.chunk_every(3, 1, :discard)
    # |> IO.inspect(label: "chunked3")
    |> Enum.map(&Enum.sum/1)
    # |> IO.inspect(label: "sum")
    |> Enum.chunk_every(2, 1, :discard)
    # |> IO.inspect(label: "chunked2")
    |> Enum.count(fn [a, b] -> b > a end)
  end
end
