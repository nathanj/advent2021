defmodule Day7 do
  @moduledoc """
  Day7

  ## Examples

      iex> data = "16,1,2,0,4,2,7,1,2,14"
      iex> Day7.pt1(data)
      37
      iex> Day7.pt2(data)
      168
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day7.txt"))
  end

  def doit(data) do
    Advent2021.print("day  7 part 1", :timer.tc(Day7, :pt1, [data]))
    Advent2021.print("day  7 part 2", :timer.tc(Day7, :pt2, [data]))
  end

  defp parse(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp fuel_cost(steps) do
    div(steps * (steps + 1), 2)
  end

  def pt1(data) do
    data = parse(data)
    min = Enum.min(data)
    max = Enum.max(data)

    Enum.map(min..max, fn x ->
      Enum.map(data, fn y -> abs(y - x) end)
    end)
    |> Enum.map(&Enum.sum/1)
    |> Enum.min()
  end

  def pt2(data) do
    data = parse(data)
    min = Enum.min(data)
    max = Enum.max(data)

    Enum.map(min..max, fn x ->
      Enum.map(data, fn y -> fuel_cost(abs(y - x)) end)
    end)
    |> Enum.map(&Enum.sum/1)
    |> Enum.min()
  end
end
