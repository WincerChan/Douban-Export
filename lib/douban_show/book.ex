defmodule DoubanShow.Book do
  import DoubanShow
  use GenServer

  @internel 15
  @url_prefix "https://book.douban.com/people"
  @douban_id Application.get_env(:douban_show, :doubanid)

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def concat_url(num) do
    "#{@url_prefix}/#{@douban_id}/collect?start=#{num * @internel}"
  end

  def date(book_item) do
    book_item
    |> Floki.find(".date")
    |> Floki.text(deep: false)
    |> String.split("\n")
    |> hd
  end

  def title(book_item) do
    main =
      book_item
      |> Floki.find("h2 > a")
      |> Floki.attribute("title")
      |> Floki.text(deep: false)

    slave =
      book_item
      |> Floki.find("h2 span")
      |> Floki.text(deep: false)

    "#{main}#{slave}"
  end

  def rating(book_item) do
    book_item
    |> Floki.find(".short-note span:nth-child(1)")
    |> Floki.attribute("class")
    |> Floki.text(deep: false)
    |> String.at(6)
    |> get_rating
  end

  def parse(m) do
    ["book", url(m), date(m), tags(m), title(m), cover(m), rating(m), comment(m)]
    |> DoubanShow.Persist.save_record
  end

  def fetch(url) do
    url
    |> parse_content
    |> Floki.find(".subject-item")
    |> Enum.map(&parse/1)
  end

  def start do
    0..fetch_pages("book")
    |> Stream.map(&concat_url/1)
    |> Enum.map(&Task.async(fn -> fetch(&1) end))
    |> Task.yield_many()
  end

  def init(state) do
    IO.puts("Starting...")
    start()
    DoubanShow.Persist.close()
    IO.puts("Done.")
    {:ok, state}
  end
end
