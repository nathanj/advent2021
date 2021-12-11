defmodule Day6 do
  @moduledoc """
  Day6

  ## Examples

      iex> data = "3,4,3,1,2"
      iex> Day6.pt1(data)
      5934
      iex> Day6.pt2(data)
      26984457539
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day6.txt"))
  end

  def doit(data) do
    Advent2021.print("day  6 part 1", :timer.tc(Day6, :pt1, [data]))
    Advent2021.print("day  6 part 2", :timer.tc(Day6, :pt2, [data]))
  end

  defp parse(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defmemo calc_fish(timer, num_days) do
    if timer < num_days do
      days_remaining = num_days - timer
      calc_fish(7, days_remaining) + calc_fish(9, days_remaining)
    else
      1
    end
  end

  def pt1(data) do
    parse(data)
    |> Enum.map(fn x -> calc_fish(x, 80) end)
    |> Enum.sum()
  end

  def pt2(data) do
    parse(data)
    |> Enum.map(fn x -> calc_fish(x, 256) end)
    |> Enum.sum()
  end
end
