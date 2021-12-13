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

  defp fold_paper(grid, {direction, position}) do
    length_y = Matrix.height(grid)
    length_x = Matrix.width(grid)

    map = Matrix.to_sparse_map(grid)

    if direction == :y do
      new_length_y = max(position, length_y - position)
      new_grid = Matrix.new(new_length_y, length_x)

      Enum.reduce(1..(new_length_y - 1), new_grid, fn y, new_grid ->
        Enum.reduce(0..(length_x - 1), new_grid, fn x, new_grid ->
          if Map.get(map, [position - y, x]) != nil or Map.get(map, [position + y, x]) != nil do
            put_in(new_grid[position - y][x], 1)
          else
            new_grid
          end
        end)
      end)
    else
      new_length_x = max(position, length_x - position)
      new_grid = Matrix.new(length_y, new_length_x)

      Enum.reduce(0..(length_y - 1), new_grid, fn y, new_grid ->
        Enum.reduce(1..(new_length_x - 1), new_grid, fn x, new_grid ->
          if Map.get(map, [y, position - x]) != nil or Map.get(map, [y, position + x]) != nil do
            put_in(new_grid[y][position - x], 1)
          else
            new_grid
          end
        end)
      end)
    end
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
    max_x =
      points
      |> Enum.map(&Enum.at(&1, 0))
      |> Enum.max()

    max_y =
      points
      |> Enum.map(&Enum.at(&1, 1))
      |> Enum.max()

    grid = Matrix.new(max_y + 1, max_x + 1)

    Enum.reduce(points, grid, fn [x, y], grid ->
      put_in(grid[y][x], 1)
    end)
  end

  def pt1(data) do
    {points, instructions} = parse(data)

    grid = create_grid(points)

    instructions
    |> Enum.take(1)
    |> Enum.reduce(grid, fn instruction, grid ->
      fold_paper(grid, instruction)
    end)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  def pt2(data) do
    {points, instructions} = parse(data)

    grid = create_grid(points)

    instructions
    |> Enum.reduce(grid, fn instruction, grid ->
      fold_paper(grid, instruction)
    end)
    |> print_digits
    |> then(fn _ -> 0 end)
  end
end
