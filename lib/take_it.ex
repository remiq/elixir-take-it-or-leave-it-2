defmodule TakeIt do

  def new_state, do: {0, 0, Enum.shuffle(1..10_000)}

  def money({val, _, _}), do: val
  def highest({_, val, _}), do: val
  def length({_, _, stack}), do: Kernel.length(stack)

  def read({_, _, [value|_]}), do: value
  def rest({_, _, stack}), do: Enum.shuffle(stack)
  def take({money, highest, [value|rest]}) when highest < value, do: {money + value, value, rest}
  def take(state), do: pass(state)
  def pass({money, highest, [_|rest]}), do: {money, highest, rest}

  
  def one({money, _, []}, _) do 
    IO.inspect(money)
    money
  end
  def one(state, algo), do: one(algo.(state), algo)

  def test(algo, n \\ 50) do
    [score] = (1..n)
      |> Enum.map(fn _ -> one(new_state, algo) end)
      |> Enum.sort
      |> Enum.slice(div(n,2), 1)
    score
  end

  ## Examples of algorythms

  # fast, 70k
  def test_simple, do: TakeIt.test fn state -> algo_simple(state) end
  def algo_simple(state) do
    take(state)
  end

  # fast, 610k
  def test_despair, do: TakeIt.test fn state -> algo_despair(state) end
  def algo_despair(state) do
    val = 10_000 - TakeIt.length(state)
    if read(state) < val do
      take(state)
    else
      pass(state)
    end
  end

  # slow
  # 1   ->  20k
  # 1.08-> 610k
  # 1.25-> 450k
  # 1.33-> 370k
  def test_regret(regret_val \\ 1.5), do: TakeIt.test fn state -> algo_regret(state, regret_val) end
  def algo_regret(state, regret_val \\ 1.5) do
    old_highest = highest(state)
    value = read(state)
    old_candidates = rest(state) |> Enum.filter(fn x -> x >= old_highest end)
    new_candidates = old_candidates |> Enum.filter(fn x -> x >= value end)
    sum_old = Enum.reduce(old_candidates, 0, fn x, acc -> acc + x end)
    sum_new = Enum.reduce(new_candidates, 0, fn x, acc -> acc + x end)
    #IO.inspect({sum_old, sum_new})
    if (sum_new * regret_val) >= sum_old do
      take(state)
    else
      pass(state)
    end
  end

end
