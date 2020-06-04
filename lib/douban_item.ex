defmodule DoubanItem do
  use GenServer

  def new do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    {:ok, []}
  end

  def put(pid, value) do
    GenServer.cast(pid, {:put, value})
  end

  def get(pid) do
    GenServer.call(pid, {:get})
  end

  def identify(pid) do
    GenServer.cast(pid, {:identify})
  end

  def handle_cast(value, inst) do
    case value do
      {:put, value} -> {:noreply, [value | inst]}
      {:identify} -> case String.printable?(inst |> hd) do
        true -> {:noreply, [id(inst) | inst]}
        # already indentified
        false -> {:noreply, inst}
      end
    end
  end

  def handle_call({:get}, _, inst) do
    {:reply, inst, inst}
  end

  defp id(item) do
    :crypto.hash(:sha3_256, inspect(item))
  end
end
