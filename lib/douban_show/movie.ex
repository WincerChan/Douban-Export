defmodule DoubanShow.Movie do
  import Tool
  use GenServer

  @internel 15
  @url_prefix "https://movie.douban.com/people"
  @douban_id Application.get_env(:douban_show, :doubanid)

  # def start_link(_) do
  #   IO.puts("Starting collecting Douban user #{@douban_id}'s movies")
  #   GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  # end

  def concat_url(num) do
    "#{@url_prefix}/#{@douban_id}/collect?start=#{num * @internel}"
  end

  def fetch({pid, num}) do
    url = concat_url(num)
    GenServer.cast(pid, {:get, url})
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
    {:ok, pid} = DoubanItem.new()

    DoubanItem.put(pid, comment(m))
    DoubanItem.put(pid, rating(m))
    DoubanItem.put(pid, cover(m))
    DoubanItem.put(pid, title(m))
    DoubanItem.put(pid, tags(m))
    DoubanItem.put(pid, date(m))
    DoubanItem.put(pid, url(m))
    DoubanItem.put(pid, "book")
    DoubanItem.identify(pid)

    DoubanItem.get(pid)
    |> DoubanShow.Persist.save_record
  end

  def handle_cast({:get, url}, state) do
    url
    |> parse_content
    |> Floki.find(".item")
    |> Enum.map(&parse/1)
    IO.puts("URL #{url} Done.")
    {:noreply, state}
  end

  def start do
    GenServer.start(DoubanShow.Movie, nil)
  end

  def init(state) do
    # start()
    {:ok, state}
  end
end
