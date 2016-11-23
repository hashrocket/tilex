defmodule TodayILearned.PostTest do
  use TodayILearned.ModelCase

  alias TodayILearned.Post

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  @invalid_attrs_title %{
    body: "some content",
    title: "You'll never believe what a long, verbose title this is.",
  }

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with title longer than 50 characters" do
    changeset = Post.changeset(%Post{}, @invalid_attrs_title)
    refute changeset.valid?
  end
end
