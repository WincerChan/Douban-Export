defmodule MovieTest do
  use ExUnit.Case
  @douban_id Application.get_env(:douban_show, :doubanid)

  @movie_item {"div", [{"class", "item"}],
               [
                 {"div", [{"class", "pic"}],
                  [
                    {"a",
                     [
                       {"title", "세븐데이즈"},
                       {"href", "https://movie.douban.com/subject/2999500/"},
                       {"class", "nbg"}
                     ],
                     [
                       {"img",
                        [
                          {"alt", "세븐데이즈"},
                          {"src",
                           "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p642667992.jpg"},
                          {"class", ""}
                        ], []}
                     ]}
                  ]},
                 {"div", [{"class", "info"}],
                  [
                    {"ul", [],
                     [
                       {"li", [{"class", "title"}],
                        [
                          {"a",
                           [
                             {"href", "https://movie.douban.com/subject/2999500/"},
                             {"class", ""}
                           ],
                           [
                             {"em", [], ["七天 / 세븐데이즈"]},
                             "\n                             / 七日 / 七日绑票令\n                        "
                           ]}
                        ]},
                       {"li", [{"class", "intro"}],
                        [
                          "2007-11-14(韩国) / 金允珍 / 朴熙顺 / 金美淑 / 李政宪 / 杨镇宇 / 张恒善 / 崔武成 / 陈庸旭 / 吉海妍 / 張航善 / 朴成勋 / 郑宗烈 / 楊泳祚 / 裴健植 / 申成日 / 朴晟泽 / 郑栋焕 / 崔永桓 / 玉智英 / 吴光禄 / 申贤宗 / 韩国 / 元新渊 / 125分钟 / 七天 / 犯罪 / 惊悚 / 元新渊 Shin-yeon Won / 尹宰久 Jae-goo Yoon / 韩语"
                        ]},
                       {"li", [],
                        [
                          {"span", [{"class", "rating4-t"}], []},
                          {"span", [{"class", "date"}], ["2020-01-05"]},
                          {"span", [{"class", "tags"}], ["标签: 韩国 犯罪 惊悚"]}
                        ]},
                       {"li", [],
                        [
                          {"span", [{"class", "comment"}], ["最后的反转好评，大快人心；只是前戏稍有些乏。"]}
                        ]}
                     ]}
                  ]}
               ]}

  test "get movie date" do
    assert DoubanShow.Movie.date(@movie_item) == "2020-01-05"
  end

  test "get movie rating" do
    assert DoubanShow.Movie.rating(@movie_item) == 4
  end

  test "get movie title" do
    assert DoubanShow.Movie.title(@movie_item) == "七天"
  end

  test "get movie url" do
    assert DoubanShow.url(@movie_item) == "https://movie.douban.com/subject/2999500/"
  end

  test "get movie tags" do
    assert DoubanShow.tags(@movie_item) == ["韩国", "犯罪", "惊悚"]
  end

  test "test movie cover" do
    assert DoubanShow.cover(@movie_item) ==
             "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p642667992.jpg"
  end

  test "test movie comment" do
    assert DoubanShow.comment(@movie_item) == "最后的反转好评，大快人心；只是前戏稍有些乏。"
  end

  test "test concat_url" do
    assert DoubanShow.Movie.concat_url(0) ==
             "https://movie.douban.com/people/#{@douban_id}/collect?start=0"
  end
end
