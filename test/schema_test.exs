defmodule DatabaseTest do
  use ExUnit.Case

  test "get env value" do
    assert Database.get_env(:hostname) == "localhost"
  end

  test "test do_create" do
    movie_info = %{
      comment: "第二集开头，“another love story has ended in murder，i cant believe it”\n“i can”",
      cover: "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2566967861.jpg",
      date: "2019-08-25",
      tags: ["犯罪", "婚姻", "剧情", "美剧"],
      title: "致命女人 第一季",
      url: "https://movie.douban.com/subject/30401122/"
    }

    assert Database.insert(movie_info) == nil
  end
end
