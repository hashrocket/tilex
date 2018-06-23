defmodule Tilex.PostsTest do
  use Tilex.ModelCase

  alias Tilex.{Factory, Posts}

  describe ".by_developer" do
    setup do
      d1 = Factory.insert!(:developer, username: "d1", email: "d1@y.com")

      ["p1", "p2", "p3", "p4", "p5"]
      |> Enum.each(fn title -> Factory.insert!(:post, title: title, developer: d1) end)
    end

    test "it returns posts by developer with limit" do
      posts = Posts.by_developer("d1", limit: 3)
      assert length(posts) == 3
      assert Enum.map(posts, fn p -> p.title end) == ["p5", "p4", "p3"]
    end

    test "it returns posts by developer without limits" do
      posts = Posts.by_developer("d1")
      assert length(posts) == 5
      assert Enum.map(posts, & &1.title) == ["p5", "p4", "p3", "p2", "p1"]
    end
  end
end
