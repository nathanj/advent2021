defmodule Day12 do
  @moduledoc """
  Day12

  ## Examples

      iex> data = """
      ...> start-A
      ...> start-b
      ...> A-c
      ...> A-b
      ...> b-d
      ...> A-end
      ...> b-end
      ...> """
      iex> Day12.pt1(data)
      10
      iex> Day12.pt2(data)
      36
      iex> data2 = """
      ...> dc-end
      ...> HN-start
      ...> start-kj
      ...> dc-start
      ...> dc-HN
      ...> LN-dc
      ...> HN-end
      ...> kj-sa
      ...> kj-HN
      ...> kj-dc
      ...> """
      iex> Day12.pt1(data2)
      19
      iex> Day12.pt2(data2)
      103
      iex> data3 = """
      ...> fs-end
      ...> he-DX
      ...> fs-he
      ...> start-DX
      ...> pj-DX
      ...> end-zg
      ...> zg-sl
      ...> zg-pj
      ...> pj-he
      ...> RW-he
      ...> fs-DX
      ...> pj-RW
      ...> zg-RW
      ...> start-pj
      ...> he-WI
      ...> zg-he
      ...> pj-fs
      ...> start-RW
      ...> """
      iex> Day12.pt1(data3)
      226
      iex> Day12.pt2(data3)
      3509
  """

  use Memoize

  def doit() do
    doit(File.read!("inputs/day12.txt"))
  end

  def doit(data) do
    Advent2021.print("day 12 part 1", :timer.tc(Day12, :pt1, [data]))
    Advent2021.print("day 12 part 2", :timer.tc(Day12, :pt2, [data]))
  end

  defp traverse_graph(graph) do
    traverse_graph_rec(graph, [], ["start"], "start", [])
  end

  defp traverse_graph_pt2(graph) do
    traverse_graph_pt2_rec(graph, [], ["start"], "start", [])
  end

  def is_cap(char) do
    char >= "A" and char <= "Z"
  end

  defp traverse_graph_rec(graph, all_paths, path_so_far, current_node, seen) do
    if current_node == "end" do
      [path_so_far | all_paths]
    else
      seen = if is_cap(current_node), do: seen, else: [current_node | seen]
      possible_nodes = Map.get(graph, current_node)
      possible_nodes = if is_nil(possible_nodes), do: [], else: possible_nodes -- seen

      if length(possible_nodes) == 0 do
        []
      else
        Enum.flat_map(possible_nodes, fn node ->
          path = [node | path_so_far]
          traverse_graph_rec(graph, all_paths, path, node, seen)
        end)
      end
    end
  end

  defp contains_dupes(seen) do
    length(seen) != length(Enum.uniq(seen))
  end

  defp traverse_graph_pt2_rec(graph, all_paths, path_so_far, current_node, seen) do
    if current_node == "end" do
      [path_so_far | all_paths]
    else
      seen = if is_cap(current_node), do: seen, else: [current_node | seen]
      possible_nodes = Map.get(graph, current_node)
      possible_nodes = if is_nil(possible_nodes), do: [], else: possible_nodes

      possible_nodes =
        if contains_dupes(seen) do
          possible_nodes -- seen
        else
          possible_nodes -- ["start"]
        end

      if length(possible_nodes) == 0 do
        []
      else
        Enum.flat_map(possible_nodes, fn node ->
          path = [node | path_so_far]
          traverse_graph_pt2_rec(graph, all_paths, path, node, seen)
        end)
      end
    end
  end

  defp build_graph(data) do
    data =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, "-") end)

    (data ++
       (data
        |> Enum.map(fn [x, y] -> [y, x] end)))
    |> Enum.group_by(&List.first/1, fn x -> Enum.at(x, 1) end)
  end

  def pt1(data) do
    data
    |> build_graph
    |> traverse_graph
    |> Enum.count()
  end

  def pt2(data) do
    data
    |> build_graph
    |> traverse_graph_pt2
    |> Enum.count()
  end
end
