defmodule Day3 do
  @moduledoc """
  Day3

  ## Examples

      iex> data = [
      ...>  "00100",
      ...>  "11110",
      ...>  "10110",
      ...>  "10111",
      ...>  "10101",
      ...>  "01111",
      ...>  "00111",
      ...>  "11100",
      ...>  "10000",
      ...>  "11001",
      ...>  "00010",
      ...>  "01010"
      ...> ]
      iex> Day3.pt1(data)
      198
      iex> Day3.pt2(data)
      230
  """

  def doit() do
    data =
      File.stream!("day3.txt")
      |> Enum.map(&String.trim/1)

    IO.puts("day 3 pt 1: #{pt1(data)}")
    IO.puts("day 3 pt 2: #{pt2(data)}")
  end

  defp count_zeroes(data) do
    Enum.count(data, fn x -> x == "0" end)
  end

  defp count_ones(data) do
    Enum.count(data, fn x -> x == "1" end)
  end

  defp gamma_digit(data) do
    if count_zeroes(data) > count_ones(data) do
      "0"
    else
      "1"
    end
  end

  defp epsilon_digit(data) do
    if count_zeroes(data) > count_ones(data) do
      "1"
    else
      "0"
    end
  end

  defp binary_list_to_integer(digits) do
    List.to_integer(to_charlist(Enum.join(digits)), 2)
  end

  def pt1(data) do
    length = String.length(Enum.at(data, 0))

    data =
      Enum.map(0..(length - 1), fn x ->
        Enum.map(data, fn y -> String.at(y, x) end)
      end)

    gamma =
      Enum.map(data, fn x -> gamma_digit(x) end)
      |> binary_list_to_integer

    epsilon =
      Enum.map(data, fn x -> epsilon_digit(x) end)
      |> binary_list_to_integer

    gamma * epsilon
  end

  def pt2(data) do
    oxygen =
      find_most_common(data, 0, &oxygen_comparer/1)
      |> binary_list_to_integer

    co2 =
      find_most_common(data, 0, &co2_comparer/1)
      |> binary_list_to_integer

    oxygen * co2
  end

  defp find_most_common(data, index, compare_fn) do
    # IO.inspect(data, label: :data)
    if length(data) == 1 do
      data
    else
      data = keep_most_common(data, index, compare_fn)
      find_most_common(data, index + 1, compare_fn)
    end
  end

  defp oxygen_comparer(digits) do
    if count_ones(digits) >= count_zeroes(digits) do
      "1"
    else
      "0"
    end
  end

  defp co2_comparer(digits) do
    if count_zeroes(digits) <= count_ones(digits) do
      "0"
    else
      "1"
    end
  end

  defp keep_most_common(data, index, compare_fn) do
    digits = Enum.map(data, fn x -> String.at(x, index) end)
    most_common = compare_fn.(digits)
    Enum.filter(data, fn x -> String.at(x, index) == most_common end)
  end
end
