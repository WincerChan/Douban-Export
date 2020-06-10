defmodule DoubanShowTest do
  use ExUnit.Case

  test "get mute output" do
    assert Tool.mute_output("fdsal") == nil
  end

  test "get resp" do
    assert Tool.parse_content("https://www.douban.com/404") == []
  end

  test "test concat url by type" do
    assert Tool.concat_url_by_type("book") ==
             "https://book.douban.com/people/93562087/collect"

    assert Tool.concat_url_by_type("movie") ==
             "https://movie.douban.com/people/93562087/collect"
  end

  test "test fetch pages" do
    assert Tool.fetch_pages("404") == -1
  end
end
