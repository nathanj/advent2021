defmodule Day14 do
  @moduledoc """
  Day14

  ## Examples

      iex> data = """
      ...> NNCB
      ...>
      ...> BB -> N
      ...> BC -> B
      ...> BH -> H
      ...> BN -> B
      ...> CB -> H
      ...> CC -> N
      ...> CH -> B
      ...> CN -> C
      ...> HB -> C
      ...> HC -> B
      ...> HH -> N
      ...> HN -> C
      ...> NB -> B
      ...> NC -> B
      ...> NH -> C
      ...> NN -> C
      ...> """
      iex> Day14.pt1(data)
      1588
      iex> Day14.pt2(data)
      2188189693529
  """

  def doit() do
    doit(File.read!("inputs/day14.txt"))
  end

  def doit(data) do
    Advent2021.print("day 14 part 1", :timer.tc(Day14, :pt1, [data]))
    Advent2021.print("day 14 part 2", :timer.tc(Day14, :pt2, [data]))
  end

  defp parse_rule(rule) do
    match = Regex.run(~r/(\w)(\w) -> (\w)/, rule)
    %{[Enum.at(match, 1), Enum.at(match, 2)] => Enum.at(match, 3)}
  end

  defp parse(data) do
    [template, rules] = String.split(data, "\n\n", trim: true)
    template = String.graphemes(template)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn rule, rules ->
        Map.merge(rules, parse_rule(rule))
      end)

    {template, rules}
  end

  defp process(template, rules) do
    template
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn x ->
      if r = Map.get(rules, x) do
        [_ | t] = x
        [r | t]
      else
        x
      end
    end)
    |> List.flatten()
    |> then(fn x -> [List.first(template)] ++ x end)
  end

  def pt1(data) do
    {template, rules} = parse(data)

    frequencies =
      Enum.reduce(1..10, template, fn _, template ->
        process(template, rules)
      end)
      |> Enum.frequencies()
      |> Map.to_list()
      |> Enum.sort_by(fn {_, v} -> v end)

    min = List.first(frequencies) |> elem(1)
    max = List.last(frequencies) |> elem(1)
    max - min
  end

  defp process_efficient(template, rules) do
    template
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {pair, count}, new_template ->
      v = Map.get(rules, pair)
      [h, t] = pair

      {_, new_template} =
        Map.get_and_update(new_template, [h, v], fn x ->
          if is_nil(x), do: {x, count}, else: {x, x + count}
        end)

      {_, new_template} =
        Map.get_and_update(new_template, [v, t], fn x ->
          if is_nil(x), do: {x, count}, else: {x, x + count}
        end)

      new_template
    end)
  end

  defp to_pair_count(template) do
    template
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.frequencies()
  end

  defp char_counts(template, last_char) do
    template
    |> Enum.group_by(fn {[a, _], _} -> a end, fn {[_, _], v} -> v end)
    |> Enum.map(fn {k, v} ->
      sum = if last_char == k, do: Enum.sum(v) + 1, else: Enum.sum(v)
      {k, sum}
    end)
    |> Enum.sort_by(fn {_, v} -> v end)
  end

  def pt2(data) do
    {template, rules} = parse(data)

    last_char = List.last(template)
    template = to_pair_count(template)

    frequencies =
      Enum.reduce(1..40, template, fn _, template ->
        process_efficient(template, rules)
      end)
      |> char_counts(last_char)

    min = List.first(frequencies) |> elem(1)
    max = List.last(frequencies) |> elem(1)
    max - min
  end
end
