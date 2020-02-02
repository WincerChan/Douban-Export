defmodule DoubanShow do
  @moduledoc """
  Documentation for DoubanShow.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DoubanShow.hello()
      :world

  """
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    # GenServer.start(DoubanShow, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def collect(server_pid, {category, page}) do
    GenServer.call(server_pid, {:douban_process, category, page})
  end

  def handle_call({:douban_process, category, page}, caller, state) do
    spawn(fn ->
      module = case category do
        :movie ->
          DoubanShow.Movie
        :book ->
          DoubanShow.Book
      end
      module.fetch(page)

      # responds from spawn process
      GenServer.reply(caller, {:ok, page})
    end)
    {:noreply, state}
  end

end
