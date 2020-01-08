defmodule DoubanShowDup do
  @moduledoc """
  Documentation for DoubanShowDup.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DoubanShowDup.hello()
      :world

  """
  def parse_content(url) do
    IO.puts(url) |> mute_output
    case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{
            status_code: 200, body: body}} ->
            Floki.parse_document(body)
        _ ->
            Floki.parse_document("")
    end
    |> elem(1)
  end

  def mute_output(_) do
  end

  def decr(num) do
    num-1
  end

  def concat_tuple(value, field) do
    # Know that params position
    {field, value}
  end
end
