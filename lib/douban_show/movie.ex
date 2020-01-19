defmodule DoubanShow.Movie do
  import DoubanShow
  use GenServer

  @internel 15
  @url_prefix "https://movie.douban.com/people"
  @douban_id Application.get_env(:douban_show, :doubanid)

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def concat_url(num) do
    "#{@url_prefix}/#{@douban_id}/collect?start=#{num * @internel}"
  end

  def fetch(url) do
    url
    |> parse_content
    |> Floki.find(".item")
    |> Enum.map(&parse/1)
  end

  def date(movie_item) do
    movie_item
    |> Floki.find(".date")
    |> Floki.text(deep: false)
  end

  def title(movie_item) do
    movie_item
    |> Floki.find("li:nth-child(1)>a>em")
    |> Floki.text(deep: false)
    |> String.split(" / ")
    |> hd
  end

  def rating(movie_item) do
    movie_item
    |> Floki.find("li:nth-child(3)>span:nth-child(1)")
    |> Floki.attribute("class")
    |> Floki.text(deep: false)
    |> String.at(6)
    |> get_rating
  end

  def parse(m) do
    ["movie", url(m), date(m), tags(m), title(m), cover(m), rating(m), comment(m)]
    |> DoubanShow.Persist.save_record
  end

  def start do
    0..fetch_pages("movie")
    |> Stream.map(&concat_url/1)
    |> Enum.map(&Task.async(fn -> fetch(&1) end))
    |> Task.yield_many()
  end

  def init(state) do
    IO.puts("Starting...")
    start()
    IO.puts("Done.")
    {:ok, state}
  end
end
