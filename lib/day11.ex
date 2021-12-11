defmodule Day11 do
  @moduledoc """
  Day11

  ## Examples


      iex> data = """
      ...> 5483143223
      ...> 2745854711
      ...> 5264556173
      ...> 6141336146
      ...> 6357385478
      ...> 4167524645
      ...> 2176841721
      ...> 6882881134
      ...> 4846848554
      ...> 5283751526
      ...> """
      iex> Day11.pt1(data)
      1656
      iex> Day11.pt2(data)
      195
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day11.txt"))
  end

  def doit(data) do
    Advent2021.print("day 11 part 1", :timer.tc(Day11, :pt1, [data]))
    Advent2021.print("day 11 part 2", :timer.tc(Day11, :pt2, [data]))
  end

  defp parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn x ->
      Enum.map(x, fn y ->
        %{value: String.to_integer(y), flashed: false}
      end)
    end)
  end

  defp grid_get(grid, i, j), do: Enum.at(Enum.at(grid, i), j)

  defp grid_replace(grid, i, j, value) do
    List.replace_at(grid, i, List.replace_at(Enum.at(grid, i), j, value))
  end

  defp increment_neighbor(grid, i, j) do
    if i < 0 or i >= length(grid) or j < 0 or j >= length(grid) do
      grid
    else
      octopus = grid_get(grid, i, j)
      grid_replace(grid, i, j, %{octopus | value: octopus.value + 1})
    end
  end

  defp increment_neighbors(grid, i, j) do
    grid = increment_neighbor(grid, i - 1, j - 1)
    grid = increment_neighbor(grid, i - 1, j - 0)
    grid = increment_neighbor(grid, i - 1, j + 1)
    grid = increment_neighbor(grid, i - 0, j - 1)
    grid = increment_neighbor(grid, i - 0, j - 0)
    grid = increment_neighbor(grid, i - 0, j + 1)
    grid = increment_neighbor(grid, i + 1, j - 1)
    grid = increment_neighbor(grid, i + 1, j - 0)
    increment_neighbor(grid, i + 1, j + 1)
  end

  defp reset_values(grid) do
    grid
    |> Enum.map(fn row ->
      Enum.map(row, fn col ->
        if col.flashed do
          %{col | value: 0, flashed: false}
        else
          col
        end
      end)
    end)
  end

  defp handle_flashes_rec(grid) do
    {grid, flashes} = handle_flashes(grid)

    if flashes > 0 do
      {grid, flashes2} = handle_flashes_rec(grid)
      {grid, flashes + flashes2}
    else
      {reset_values(grid), flashes}
    end
  end

  defp handle_flashes(grid) do
    i_range = 0..(length(grid) - 1)
    j_range = 0..(length(List.first(grid)) - 1)

    Enum.reduce(i_range, {grid, 0}, fn i, {grid, flashes} ->
      Enum.reduce(j_range, {grid, flashes}, fn j, {grid, flashes} ->
        octopus = grid_get(grid, i, j)

        if octopus.value > 9 and !octopus.flashed do
          grid = grid_replace(grid, i, j, %{octopus | flashed: true})
          {increment_neighbors(grid, i, j), flashes + 1}
        else
          {grid, flashes}
        end
      end)
    end)
  end

  defp perform_step(grid) do
    grid
    |> Enum.map(fn row ->
      Enum.map(row, fn col ->
        %{col | value: col.value + 1}
      end)
    end)
    |> handle_flashes_rec
  end

  def pt1(data) do
    grid = parse(data)

    Enum.reduce(1..100, {grid, 0}, fn _, {grid, flashes} ->
      {grid, n} = perform_step(grid)
      {grid, flashes + n}
    end)
    |> elem(1)
  end

  defp find_simul_flash(grid) do
    Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), grid, fn i, grid ->
      {grid, flashes} = perform_step(grid)

      if flashes == length(grid) * length(grid) do
        {:halt, i}
      else
        {:cont, grid}
      end
    end)
  end

  def pt2(data) do
    parse(data) |> find_simul_flash
  end
end
