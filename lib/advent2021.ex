defmodule Advent2021 do
  use Application

  @moduledoc """
  Documentation for `Advent2021`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Advent2021.hello()
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do
    Day1.doit()
    Day2.doit()
    Day3.doit()
    Day4.doit()
    Day5.doit()
    Day6.doit()
    Day7.doit()
    Day8.doit()
    Day9.doit()
    Day10.doit()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def print(str, {time, value}) do
    value = value |> Integer.to_string() |> String.pad_trailing(20, " ")
    time = div(time, 1000) |> Integer.to_string() |> String.pad_leading(3, " ")
    IO.puts("#{str} = #{value} ( #{time} ms )")
  end
end
