defmodule Day2 do
  @moduledoc """
  Day2

  ## Examples

      iex> Day2.pt1(["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"])
      150
      iex> Day2.pt2(["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"])
      900
  """

  def doit() do
    data =
      File.stream!("inputs/day2.txt")
      |> Enum.map(&String.trim/1)

    IO.puts("day 2 pt 1: #{pt1(data)}")
    IO.puts("day 2 pt 2: #{pt2(data)}")
  end

  def handle_cmd(cmd, state) do
    cond do
      match = Regex.run(~r/forward (\d+)/, cmd) ->
        [_, amt] = match
        amt = String.to_integer(amt)
        %{state | :horizontal => state.horizontal + amt}

      match = Regex.run(~r/up (\d+)/, cmd) ->
        [_, amt] = match
        amt = String.to_integer(amt)
        %{state | :depth => state.depth - amt}

      match = Regex.run(~r/down (\d+)/, cmd) ->
        [_, amt] = match
        amt = String.to_integer(amt)
        %{state | :depth => state.depth + amt}

      true ->
        IO.puts("could not parse cmd: #{cmd}")
        state
    end
  end

  def handle_cmd_pt2(cmd, state) do
    cond do
      match = Regex.run(~r/forward (\d+)/, cmd) ->
        [_, amt] = match
        amt = String.to_integer(amt)
        %{state | :horizontal => state.horizontal + amt, :depth => state.depth + state.aim * amt}

      match = Regex.run(~r/up (\d+)/, cmd) ->
        [_, amt] = match
        amt = String.to_integer(amt)
        %{state | :aim => state.aim - amt}

      match = Regex.run(~r/down (\d+)/, cmd) ->
        [_, amt] = match
        amt = String.to_integer(amt)
        %{state | :aim => state.aim + amt}

      true ->
        IO.puts("could not parse cmd: #{cmd}")
        state
    end
  end

  def get_value(state) do
    state.horizontal * state.depth
  end

  def initial_state() do
    %{horizontal: 0, depth: 0, aim: 0}
  end

  def pt1(data) do
    data
    |> Enum.reduce(initial_state(), &handle_cmd/2)
    |> get_value
  end

  def pt2(data) do
    data
    |> Enum.reduce(initial_state(), &handle_cmd_pt2/2)
    |> get_value
  end
end
