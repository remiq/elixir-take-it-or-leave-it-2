defmodule TakeIt do

  def new_state do
    {0, 0, Enum.shuffle(1..10_000)}
  end

  def money(state), do: elem(state, 0)
  def highest(state), do: elem(state, 1)
  def length(state), do: Kernel.length(elem(state, 2))

  def read({_, _, [value|_]}), do: value
  def take({money, highest, [value|rest]}) when highest < value, do: {money + value, value, rest}
  def take(state), do: pass(state)
  def pass({money, highest, [_|rest]}), do: {money, highest, rest}

end
