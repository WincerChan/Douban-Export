defmodule Show do
  alias :mnesia, as: Mnesia

  def init do
    Mnesia.start()
  end

  def this_year do
    Date.utc_today()
    |> Date.add(-Date.day_of_year(Date.utc_today()))
    |> Date.to_iso8601()
  end

  def get_this_year do
    Mnesia.dirty_select(
      :douban,
      [
        {{:douban, :"$1", :"$2", :"$3", :"$4", :"$5", :"$6", :"$7", :"$8", :"$9"},
         [{:>, :"$4", this_year()}], [:"$$"]}
      ]
    )
    |> Enum.sort_by(&Enum.at(&1, 3))
  end

  def draw(item) do
    [_, category, url, date, _, title, cover, _, _] = item

    IO.puts(
      "{% figure '#{cover}' '#{title}' '#{url}' '#{
        date <> if category == "book", do: " 读过", else: " 看过"
      }' %}"
    )
  end

  def start do
    init()

    get_this_year()
    |> Stream.map(&draw/1)
    |> Enum.to_list()
  end
end
