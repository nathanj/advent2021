defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "pt1" do
    assert Day1.pt1([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7
  end

  test "pt2" do
    assert Day1.pt2([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 5
  end
end
