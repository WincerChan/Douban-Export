defmodule Book do
    def fetch(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)
        {:ok, document} = Floki.parse_document body

        document
        |> Floki.find(".subject-item")
        # |> Enum.map(&parse/1)
    end

    def get_rating(rating) do
        if rating != nil do
            String.to_integer(rating)
        end
    end
end