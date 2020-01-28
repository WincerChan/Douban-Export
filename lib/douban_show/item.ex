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

  def handle_cast({:put, value}, inst) do
    {:noreply, [value | inst]}
  end

  def handle_call({:get}, _, inst) do
    {:reply, inst, inst}
  end

  def handle_cast({:identify}, inst) do
    case String.printable?(inst |> hd) do
      true -> {:noreply, [id(inst) | inst]}
      false -> {:noreply, inst}  # already indentified
    end
  end

  defp id(item) do
    :crypto.hash(:sha3_256, inspect(item))
  end
end
