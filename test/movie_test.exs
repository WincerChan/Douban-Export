defmodule MovieTest do
  use ExUnit.Case

  test "get get_rating error" do
    assert Movie.get_rating(nil) == nil
  end

  test "get get_rating succ" do
    assert Movie.get_rating("4") == 4
  end

  test "get concat_tuple" do
    assert Movie.concat_tuple(:title, "Hello") ==
             {"Hello", :title}
  end
end
