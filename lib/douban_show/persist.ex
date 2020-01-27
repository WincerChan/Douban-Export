# This module should be server
defmodule DoubanShow.Persist do
  use GenServer

  alias :mnesia, as: Mnesia

  @table :douban
  @attributes [
    :id,
    :category,
    :url,
    :date,
    :tags,
    :title,
    :cover,
    :rating,
    :comment
  ]
  def do_save(item) do
    [@table | item]
    |> List.to_tuple()
    |> Mnesia.write()
  end

  def save_record(record) do
    GenServer.cast(__MODULE__, {:save, record})
  end

  def get_record(key) do
    GenServer.cast(__MODULE__, {:get, key})
  end

  # save record
  def handle_cast({:save, record}, state) do
    Mnesia.transaction(fn ->
      do_save(record)
    end) |> IO.inspect

    {:noreply, state}
  end

  # get record, now unused
  def handle_cast({:get, key}, _, state) do
    data =
    case Mnesia.dirty_read(@table, key) do
      [data | _] -> data
      _ -> nil
    end

    {:reply, data, state}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Mnesia.create_schema([node()])
    Mnesia.start()
    Mnesia.create_table(@table, attributes: @attributes, disc_only_copies: [node()])

    {:ok, nil}
  end

  def close do
    Mnesia.stop()
  end
end
