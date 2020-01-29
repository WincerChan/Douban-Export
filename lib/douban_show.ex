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
  def start do
    # GenServer.start_link(__MODULE__, nil, __MODULE__)
    GenServer.start(DoubanShow, nil)
  end

  def init(_) do
    # send(self(), :real_init)
    {:ok, nil}
  end

  def handle_info(:real_init, _) do
    IO.puts("START")
  end

  def server_process(server_pid, category) do
    GenServer.call(server_pid, {:douban_process, category})
  end

  def start_fetch(server_pid, {module_info, num}) do
    GenServer.cast(server_pid, {:page, module_info, num})
  end

  # 这个地方应该接受两个参数：category（book or movie），page（0，1，2）
  # 这个地方应该还是一个参数，返回一个 pid，
  # 但是这个 pid 是一个 process，通过 cast 来接受 url
  def handle_call({:douban_process, category}, _, state) do
    IO.puts("JFHJSDHGFJD")
    case category do
      :movie ->
        {:ok, movie_pid} = DoubanShow.Movie.start
        {:reply, {DoubanShow.Movie, movie_pid}, state}
      :book ->
        {:ok, book_pid} = DoubanShow.Book.start
        {:reply, {DoubanShow.Book, book_pid}, state}
    end
  end

  def handle_cast({:page, {module, pid}, num}, state) do
    spawn(fn ->
      module.fetch({pid, num})
    end)
    {:noreply, state}
  end
end
