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
    @internel 15
    @doubanid Application.get_env(:douban_show, :doubanid)
    def concat_url(num) do
        "https://movie.douban.com/people/#{@doubanid}/collect?start=#{num*@internel}"
        |> IO.puts
    end

    def crawler() do
        IO.puts("Starting ...")
        0..21
        |> Enum.map(&concat_url/1)
        |> Enum.map(&(Task.async(fn -> Movie.fetch(&1) end)))
        |> Task.yield_many
        IO.puts("Done.")
    end

    def start(_type, _args) do
        :timer.sleep(5000)
        Database.init()
        # crawler()
        concat_url(0)
        # return self pid to supervisor
        {:ok, self()}
    end
end
