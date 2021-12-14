defmodule Day13 do
  @moduledoc """
  Day13

  ## Examples

      iex> data = """
      ...> 6,10
      ...> 0,14
      ...> 9,10
      ...> 0,3
      ...> 10,4
      ...> 4,11
      ...> 6,0
      ...> 6,12
      ...> 4,1
      ...> 0,13
      ...> 10,12
      ...> 3,4
      ...> 3,0
      ...> 8,4
      ...> 1,10
      ...> 2,14
      ...> 8,10
      ...> 9,0
      ...> 
      ...> fold along y=7
      ...> fold along x=5
      ...> """
      iex> Day13.pt1(data)
      17
  """

  use Memoize
  use Tensor

  def doit() do
    doit(File.read!("inputs/day13.txt"))
  end

  def doit(data) do
    Advent2021.print("day 13 part 1", :timer.tc(Day13, :pt1, [data]))
    Advent2021.print("day 13 part 2", :timer.tc(Day13, :pt2, [data]))
  end

  defp parse_instruction(str) do
    cond do
      match = Regex.run(~r/fold along x=(\d+)/, str) ->
        {:x, String.to_integer(Enum.at(match, 1))}

      match = Regex.run(~r/fold along y=(\d+)/, str) ->
        {:y, String.to_integer(Enum.at(match, 1))}

      true ->
        nil
    end
  end

  defp parse_instructions(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_points(data) do
    data
    |> String.split("\n")
    |> Enum.map(fn a -> String.split(a, ",") end)
    |> Enum.map(fn a -> Enum.map(a, &String.to_integer/1) end)
  end

  defp parse(data) do
    data
    |> String.split("\n\n", trim: true)
    |> then(fn [x, y] -> {parse_points(x), parse_instructions(y)} end)
  end

  defp fold_paper({grid, height, width}, {direction, position}) when direction == :y do
    new_height = max(position, height - position) - 1

    offset =
      if div(height, 2) > position do
        height - 2 * position
      else
        0
      end

    grid =
      Enum.reduce(Map.keys(grid), %{}, fn [y, x], new_grid ->
        if y < position do
          Map.put(new_grid, [offset + y, x], 1)
        else
          Map.put(new_grid, [position - (y - position) + offset, x], 1)
        end
      end)

    {grid, new_height, width}
  end

  defp fold_paper({grid, height, width}, {direction, position}) when direction == :x do
    new_width = max(position, width - position) - 1

    offset =
      if div(width, 2) > position do
        width - 2 * position
      else
        0
      end

    grid =
      Enum.reduce(Map.keys(grid), %{}, fn [y, x], new_grid ->
        if x < position do
          Map.put(new_grid, [y, offset + x], 1)
        else
          Map.put(new_grid, [y, position - (x - position) + offset], 1)
        end
      end)

    {grid, height, new_width}
  end

  defp print_digits(data) do
    Enum.each(data, fn row ->
      Enum.each(row, fn col ->
        if col == 1 do
          IO.write("#")
        else
          IO.write(" ")
        end
      end)

      IO.puts("")
    end)
  end

  defp create_grid(points) do
    width =
      (points
       |> Enum.map(&Enum.at(&1, 0))
       |> Enum.max()) + 1

    height =
      (points
       |> Enum.map(&Enum.at(&1, 1))
       |> Enum.max()) + 1

    grid =
      points
      |> Enum.map(fn [x, y] -> [y, x] end)
      |> Enum.frequencies()

    {grid, height, width}
  end

  def pt1(data) do
    {points, instructions} = parse(data)

    grid = create_grid(points)

    instructions
    |> Enum.take(1)
    |> Enum.reduce(grid, fn instruction, grid ->
      fold_paper(grid, instruction)
    end)
    |> elem(0)
    |> map_size
  end

  def pt2(data) do
    {points, instructions} = parse(data)

    grid = create_grid(points)

    instructions
    |> Enum.reduce(grid, fn instruction, grid ->
      fold_paper(grid, instruction)
    end)
    |> then(fn {grid, height, width} -> Matrix.from_sparse_map(grid, height, width) end)
    |> print_digits
    |> then(fn _ -> 0 end)
  end
end
