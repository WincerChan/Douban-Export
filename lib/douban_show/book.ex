defmodule DoubanShow.Book do
  import Tool
  use GenServer

  @internel 15
  @url_prefix "https://book.douban.com/people"
  @douban_id Application.get_env(:douban_show, :doubanid)

  # def start_link(_) do
  #   IO.puts("Starting collecting Douban user #{@douban_id}'s books")
  #   GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  # end

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

  def fetch({pid, num}) do
    url = concat_url(num)
    GenServer.cast(pid, {:get, url})
  end

  def handle_cast({:get, url}, state) do
    url
    |> parse_content
    |> Floki.find(".subject-item")
    |> Enum.map(&parse/1)
    IO.puts("URL #{url} Done.")
    {:noreply, state}
  end

  def start do
    GenServer.start(DoubanShow.Book, nil)
  end

  def init(state) do
    # start()
    # DoubanShow.Persist.close()
    {:ok, state}
  end
end
