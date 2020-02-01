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
    # send(self(), :real_init)
    IO.inspect(self())
    {:ok, nil}
  end

  def handle_info(:real_init, _) do
    IO.puts("START")
    # 奇怪，本应该运行这个的，但是似乎直接 start 之后就结束了
    start_collect(self(), {:book, 0})
  end

  def start_collect(server_pid, {category, page}) do
    GenServer.call(server_pid, {:douban_process, category, page})
  end

  def start_fetch(server_pid, {module_info, num}) do
    GenServer.cast(server_pid, {:page, module_info, num})
  end

  # 这个地方应该接受两个参数：category（book or movie），page（0，1，2）
  # 这个地方应该还是一个参数，返回一个 pid，
  # 但是这个 pid 是一个 process，通过 cast 来接受 url
  def handle_call({:douban_process, category, page}, caller, state) do
    spawn(fn ->
      {module, pid} = case category do
        :movie ->
          {:ok, movie_pid} = DoubanShow.Movie.start
          {DoubanShow.Movie, movie_pid}
        :book ->
          {:ok, book_pid} = DoubanShow.Book.start
          {DoubanShow.Book, book_pid}
      end
      module.fetch({pid, page})

      # responds from spawn process
      GenServer.reply(caller, {:ok, page})
    end)
    {:noreply, state}
  end

  def handle_cast({:page, {module, pid}, num}, state) do
    spawn(fn ->
      module.fetch({pid, num})
    end)
    {:noreply, state}
  end
end
