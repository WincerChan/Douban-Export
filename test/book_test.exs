defmodule BookTest do
  use ExUnit.Case
  @douban_id Application.get_env(:douban_show, :doubanid)

  @book_item {"li", [{"class", "subject-item"}],
 [
   {"div", [{"class", "pic"}],
    [
      {"a",
       [
         {"class", "nbg"},
         {"href", "https://book.douban.com/subject/26810502/"},
         {"onclick",
          "moreurl(this,{i:'0',query:'',subject_id:'26810502',from:'book_subject_search'})"}
       ],
       [
         {"img",
          [
            {"class", ""},
            {"src",
             "https://img3.doubanio.com/view/subject/m/public/s28857893.jpg"},
            {"width", "90"}
          ], []}
       ]}
    ]},
   {"div", [{"class", "info"}],
    [
      {"h2", [{"class", ""}],
       [
         {"a",
          [
            {"href", "https://book.douban.com/subject/26810502/"},
            {"title", "暴力"},
            {"onclick",
             "moreurl(this,{i:'0',query:'',subject_id:'26810502',from:'book_subject_search'})"}
          ],
          [
            "\n\n    暴力\n\n\n    \n      ",
            {"span", [{"style", "font-size:12px;"}],
             [" : 一种微观社会学理论 "]}
          ]}
       ]},
      {"div", [{"class", "pub"}],
       ["\n        \n  \n  兰德尔·柯林斯 (Randall Collins) / 刘冉 / 北京大学出版社 / 2016-6-1 / CNY 88.00\n\n      "]},
      {"div", [{"class", "short-note"}],
       [
         {"div", [],
          [
            {"span", [{"class", "rating4-t"}], []},
            {"span", [{"class", "date"}], ["2019-08-31\n      读过"]}
          ]},
         {"p", [{"class", "comment"}],
          ["\n      没有暴力的个体，只有暴力的情境\n      \n  \n\n  "]}
       ]},
      {"div", [{"class", "ft"}],
       [
         {"div", [{"class", "cart-actions"}],
          [
            {"span", [{"class", "market-info"}],
             [
               {"a",
                [
                  {"href",
                   "https://book.douban.com/subject/26810502/?channel=subject_list&platform=web"},
                  {"target", "_blank"}
                ], ["在豆瓣购买"]}
             ]}
          ]}
       ]}
    ]}
 ]}

  test "get book date" do
    assert DoubanShow.Book.date(@book_item) == "2019-08-31"
  end

  test "get movie rating" do
    assert DoubanShow.Book.rating(@book_item) == 4
  end

  test "get movie title" do
    assert DoubanShow.Book.title(@book_item) == "暴力 : 一种微观社会学理论 "
  end

  test "get movie url" do
    assert DoubanShow.url(@book_item) == "https://book.douban.com/subject/26810502/"
  end

  test "get movie tags" do
    assert DoubanShow.tags(@book_item) == []
  end

  test "test movie cover" do
    assert DoubanShow.cover(@book_item) == "https://img3.doubanio.com/view/subject/m/public/s28857893.jpg"
  end

  test "test movie comment" do
    assert DoubanShow.comment(@book_item) == "\n      没有暴力的个体，只有暴力的情境\n      \n  \n\n  "
  end

  test "test concat_url" do
    assert DoubanShow.Book.concat_url(0) == "https://book.douban.com/people/#{@douban_id}/collect?start=0"
  end

end
