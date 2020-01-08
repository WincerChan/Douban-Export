defmodule DoubanShow.Database do
  use GenServer

  def gen_pid do
    get_app_env = fn name -> Application.get_env(:douban_show, name) end

    {:ok, pid} =
      Postgrex.start_link(
        hostname: get_app_env.(:hostname),
        username: get_app_env.(:username),
        database: get_app_env.(:database),
        password: get_app_env.(:password)
      )

    try do
      _ = Postgrex.query!(pid, "Abort;", [])
    rescue
      _ in DBConnection.ConnectionError ->
        IO.puts("Sorry, I can't connect to database.")
    end

    pid
  end

  def start_link(_) do
    state = %{:pid => gen_pid()}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def conn do
    GenServer.call(__MODULE__, :get)
  end

  def handle_call(:get, _from, state) do
    {:reply, state[:pid], state}
  end

  def handle_cast({:put, pid}, _from, state) do
    {:noreply, Map.put(state, :pid, pid)}
  end
end
