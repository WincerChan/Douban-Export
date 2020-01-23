defmodule DoubanShow.Persist do
  use GenServer

  alias :mnesia, as: Mnesia

  @table :douban
  @attributes [
    :id, :category, :url,
    :date, :tags, :title,
    :cover, :rating, :comment
  ]
  def init_mnesia do
    Mnesia.create_schema([node()])
    Mnesia.start()
    Mnesia.create_table(@table, [attributes: @attributes, disc_only_copies: [node()]])
    Mnesia.wait_for_tables([@table], 5000)
  end

  def do_save(item) do
    [@table | item]
    |> List.to_tuple
    |> Mnesia.write
  end

  def save_record(item) do
    Mnesia.transaction(
      fn ->
      do_save(item)
      end
    )
    |> IO.inspect
  end

  def start_link(_) do
    state = 1
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    init_mnesia()
    {:ok, state}
  end

  def close do
    Mnesia.stop()
  end

end
