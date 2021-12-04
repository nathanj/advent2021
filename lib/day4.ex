defmodule Day4 do
  @moduledoc """
  Day4

  ## Examples

      iex> data = """
      ...> 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
      ...>
      ...> 22 13 17 11  0
      ...>  8  2 23  4 24
      ...> 21  9 14 16  7
      ...>  6 10  3 18  5
      ...>  1 12 20 15 19
      ...>
      ...>  3 15  0  2 22
      ...>  9 18 13 17  5
      ...> 19  8  7 25 23
      ...> 20 11 10 24  4
      ...> 14 21 16 12  6
      ...>
      ...> 14 21 17 24  4
      ...> 10 16 15  9 19
      ...> 18  8 23 26 20
      ...> 22 11 13  6  5
      ...>  2  0 12  3  7
      ...> """
      iex> Day4.pt1(data)
      4512
      iex> Day4.pt2(data)
      1924
  """

  def doit() do
    doit(File.read!("day4.txt"))
  end

  def doit(data) do
    IO.puts("day 4 pt 1: #{pt1(data)}")
    IO.puts("day 4 pt 2: #{pt2(data)}")
  end

  defp is_called(num), do: num >= 10000
  defp is_row_winner(row), do: Enum.all?(row, &is_called/1)

  defp mark_called(board, num),
    do: Enum.map(board, fn x -> if x == num, do: x + 10000, else: x end)

  def is_winner(board) do
    rows =
      board
      |> Enum.chunk_every(5)

    cols =
      Enum.map(0..4, fn x ->
        board |> Enum.drop(x) |> Enum.take_every(5)
      end)

    (rows ++ cols)
    |> Enum.any?(&is_row_winner/1)
  end

  defp parse(data) do
    [called_nums | boards] = String.split(data, "\n\n")

    called_nums =
      called_nums
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn x ->
        Regex.scan(~r/\d+/, x)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)

    {called_nums, boards}
  end

  defp calc_score({num, board}) do
    sum_uncalled = board |> Enum.reject(&is_called/1) |> Enum.sum()
    num * sum_uncalled
  end

  def pt1(data) do
    {called_nums, boards} = parse(data)

    Enum.reduce_while(called_nums, boards, fn num, boards ->
      boards = Enum.map(boards, fn board -> mark_called(board, num) end)

      if Enum.any?(boards, fn board -> is_winner(board) end) do
        {:halt, {num, Enum.find(boards, &is_winner/1)}}
      else
        {:cont, boards}
      end
    end)
    |> calc_score
  end

  def pt2(data) do
    {called_nums, boards} = parse(data)

    Enum.reduce_while(called_nums, boards, fn num, boards ->
      boards = Enum.map(boards, fn board -> mark_called(board, num) end)

      if length(boards) == 1 do
        if is_winner(List.first(boards)) do
          {:halt, {num, List.first(boards)}}
        else
          {:cont, boards}
        end
      else
        boards = Enum.reject(boards, &is_winner/1)
        {:cont, boards}
      end
    end)
    |> calc_score
  end
end
