defmodule DoubanItem do
  def new, do: []

  def put(inst, value) do
    [value | inst]
  end

  defp new_id(item) do
    :crypto.hash(:sha3_256, inspect(item))
  end

  def make_id(inst) do
    with sum <- new_id(inst) do
      [sum | inst]
    end
  end
end
