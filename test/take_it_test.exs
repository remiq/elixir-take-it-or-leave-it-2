defmodule TakeItTest do
  use ExUnit.Case

  test "new state" do
    {money, highest, stack} = TakeIt.new_state
    assert money == 0
    assert highest == 0
    assert length(stack) == 10_000
    # assert random?
    {_, _, stack2} = TakeIt.new_state
    refute stack == stack2
  end

  test "read" do
    state = TakeIt.new_state
    value = TakeIt.read(state)
    assert value >= 1
    assert value <= 10_000
  end

  test "take" do
    state = TakeIt.new_state
    value = TakeIt.read(state)
    new_state = TakeIt.take(state)
    assert TakeIt.money(new_state) == TakeIt.money(state) + value
    assert TakeIt.length(new_state) == TakeIt.length(state) - 1
    assert TakeIt.highest(new_state) == value # it's first take
  end

  test "pass" do
    state = TakeIt.new_state
    new_state = TakeIt.pass(state)
    assert TakeIt.money(new_state) == TakeIt.money(state)
    assert TakeIt.length(new_state) == TakeIt.length(state) - 1
    assert TakeIt.highest(new_state) == TakeIt.highest(state)
  end

  test "taking high low" do
    state = ""
  end

end
