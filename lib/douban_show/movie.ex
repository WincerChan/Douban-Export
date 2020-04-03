defmodule DoubanShow.Movie do
  import Tool

  @internel 15
  @url_prefix "https://movie.douban.com/people"
  @douban_id Application.get_env(:douban_show, :doubanid)

  def concat_url(num) do
    "#{@url_prefix}/#{@douban_id}/collect?start=#{num * @internel}"
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
    DoubanItem.put(pid, "movie")
    DoubanItem.identify(pid)

    DoubanItem.get(pid)
    |> DoubanShow.Persist.save_record()
  end

  def fetch(page) do
    with url <- concat_url(page) do
      parse_content(url)
      |> Floki.find(".item")
      |> Enum.map(&parse/1)

      IO.puts("URL: #{url} Done.")
    end
  end
end
