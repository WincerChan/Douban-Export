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

  def fetch_pages do
    concat_url(0)
    |> parse_content
    |> Floki.find(".paginator > a:last-of-type")
    |> Floki.text(deep: false)
    |> String.to_integer()
    |> decr
  end

  def fetch(url) do
    url
    |> parse_content
    |> Floki.find(".item")
    |> Enum.map(&parse/1)
  end

  def url(movie_item) do
    movie_item
    |> Floki.find(".nbg")
    |> Floki.attribute("href")
    |> Floki.text(deep: false)
    |> concat_tuple(:url)
  end

  def date(movie_item) do
    movie_item
    |> Floki.find(".date")
    |> Floki.text(deep: false)
    |> concat_tuple(:date)
  end

  def tags(movie_item) do
    movie_item
    |> Floki.find(".tags")
    |> Floki.text(deep: false)
    |> String.split(" ")
    |> tl
    |> concat_tuple(:tags)
  end

  def title(movie_item) do
    movie_item
    |> Floki.find("li:nth-child(1)>a>em")
    |> Floki.text(deep: false)
    |> String.split(" / ")
    |> hd
    |> concat_tuple(:title)
  end

  def cover(movie_item) do
    movie_item
    |> Floki.find("img")
    |> Floki.attribute("src") |> hd
    |> concat_tuple(:cover)
  end

  def get_rating(rating_str) do
    if rating_str != nil do
      String.to_integer(rating_str)
    end
  end


  def rating(movie_item) do
    movie_item
    |> Floki.find("li:nth-child(3)>span:nth-child(1)")
    |> Floki.attribute("class")
    |> Floki.text(deep: false)
    |> String.at(6)
    |> get_rating
    |> concat_tuple(:rating)
  end

  def comment(movie_item) do
    movie_item
    |> Floki.find(".comment")
    |> Floki.text(deep: false)
    |> concat_tuple(:comment)
  end

  def parse(m) do
    [url(m), date(m), tags(m), title(m), cover(m), rating(m), comment(m)]
    |> Map.new()
    |> IO.inspect
  end

  def start do
    0..fetch_pages()
    |> Enum.map(&concat_url/1)
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
