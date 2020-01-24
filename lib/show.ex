defmodule Show do
  alias :mnesia, as: Mnesia

  def init do
    Mnesia.start()
  end

  def get_this_year do
    Mnesia.dirty_select(
      :douban,
      [
        {{:douban, :"$1", :"$2", :"$3", :"$4", :"$5", :"$6", :"$7", :"$8", :"$9"},
         [{:>, :"$4", "2020-00-00"}], [:"$$"]}
      ]
    )
    |> Enum.sort_by(&Enum.at(&1, 3))
  end

  def draw do
    init()
    get_this_year()
    |> Stream.map(
      &IO.puts("{% figure '#{&1 |> Enum.at(6)}' '#{&1 |> Enum.at(5)}' '#{&1 |> Enum.at(2)}' '#{Enum.at(&1, 3) <> if Enum.at(&1, 1) == "book", do: " 读过", else: " 看过"}' %}")
    )
    |> Enum.to_list
  end
end
