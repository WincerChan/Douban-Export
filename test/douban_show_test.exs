defmodule DoubanShowTest do
  use ExUnit.Case

  test "test concat_url" do
    assert DoubanShow.concat_url(1)
    == "https://movie.douban.com/people/93562087/collect?start=15"
  end
end