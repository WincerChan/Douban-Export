defmodule Tool do
  @douban_id Application.get_env(:douban_show, :doubanid)
  @spec concat_url_by_type(String) :: <<_::64, _::_*8>>
  def concat_url_by_type(category) do
    "https://#{category}.douban.com/people/#{@douban_id}/collect"
  end

  @spec fetch_pages(String) :: integer
  def fetch_pages(category) do
    concat_url_by_type(category)
    |> parse_content
    |> Floki.find(".paginator > a:last-of-type")
    |> Floki.text(deep: false)
    |> to_integer
    |> decr
  end

  @spec enumerate_pages(String) :: Range.t()
  def enumerate_pages(category), do: 0..fetch_pages(category)

  @spec to_integer(nil | binary) :: integer
  def to_integer(ill) when ill in [nil, ""], do: 0

  def to_integer(str), do: String.to_integer(str)

  def url(movie_item),
    do:
      movie_item
      |> Floki.find(".nbg")
      |> Floki.attribute("href")
      |> Floki.text(deep: false)

  def tags(movie_item),
    do:
      movie_item
      |> Floki.find(".tags")
      |> Floki.text(deep: false)
      |> String.split(" ")
      |> tl

  def cover(movie_item),
    do:
      movie_item
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> hd

  def get_rating(rating_str), do: to_integer(rating_str)

  def comment(movie_item),
    do:
      movie_item
      |> Floki.find(".comment")
      |> Floki.text(deep: false)

  def parse_content(url),
    do:
      HTTPoison.get(url, %{}, hackney: [cookie: ["bid=FMmHbs6EbzY"]])
      |> get_resp
      |> elem(1)

  defp get_resp({:ok, %HTTPoison.Response{status_code: 200, body: body}}),
    do: Floki.parse_document(body)

  defp get_resp(_), do: Floki.parse_document("")

  def mute_output(_), do: nil

  @spec decr(number) :: integer()
  def decr(num), do: num - 1
end
