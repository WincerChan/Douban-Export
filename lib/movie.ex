defmodule Movie do
    def fetch(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)
        {:ok, document} = Floki.parse_document(body)

        document
        |> Floki.find(".item")
        |> Enum.map(&parse/1)
    end

    def get_rating(rating_str) do
        if rating_str != nil do
            String.to_integer(rating_str)
        end
    end

    def concat_tuple(value, field) do
        # Know that params position
        {field, value}
    end

    def parse(movie_item) do
        url = fn ->
            movie_item
            |> Floki.find(".nbg") |> Floki.attribute("href")
            |> Floki.text(deep: false)
            |> concat_tuple(:url) end
        date = fn ->
            movie_item
            |> Floki.find(".date") |> Floki.text(deep: false)
            |> concat_tuple(:date) end
        tags = fn ->
            movie_item
            |> Floki.find(".tags") |> Floki.text(deep: false)
            |> String.split(" ") |> tl
            |> concat_tuple(:tags) end
        title = fn ->
            movie_item
            |> Floki.find("li:nth-child(1)>a>em")
            |> Floki.text(deep: false) |> String.split(" / ")
            |> hd |> concat_tuple(:title) end
        cover = fn ->
            movie_item
            |> Floki.find("img") |> Floki.attribute("src")
            |> hd |> concat_tuple(:cover) end
        rating = fn ->
            movie_item
            |> Floki.find("li:nth-child(3)>span:nth-child(1)")
            |> Floki.attribute("class") |> Floki.text(deep: false)
            |> String.at(6) |> get_rating
            |> concat_tuple(:rating) end
        comment = fn -> 
            movie_item
            |> Floki.find(".comment") |> Floki.text(deep: false)
            |> concat_tuple(:comment) end

        [url, date, tags, title, cover, rating, comment]
        |> Enum.map(& &1.())
        |> Map.new
        |> Database.insert
    end
end
