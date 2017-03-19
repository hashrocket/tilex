defmodule Tilex.PostTest do
  use Tilex.ModelCase

  alias Tilex.Post

  @valid_attrs %{
    body: "some content",
    title: "some content",
    channel_id: 1,
    developer_id: 1
  }

  @invalid_attrs %{}

  @invalid_attrs_title %{
    body: "some content",
    title: "You'll never believe what a long, verbose title this is.",
    channel_id: 1,
  }

  @invalid_attrs_body %{
    body: String.duplicate("wordy ", 205),
    title: "some content",
    channel_id: 1,
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

  test "changeset with body longer than 200 words" do
    changeset = Post.changeset(%Post{}, @invalid_attrs_body)
    refute changeset.valid?
  end

  test "changeset generates slug" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert String.length(Ecto.Changeset.get_change(changeset, :slug)) == 10
  end

  test "changeset does not replace slug" do
    slug = "my_existing_slug"
    changeset = Post.changeset(%Post{slug: slug}, @valid_attrs)
    assert Ecto.Changeset.get_field(changeset, :slug) == slug
  end

  test "can slugify its own title" do
    title = "Hacking Your Shower!!!"
    result = "hacking-your-shower"
    assert Post.slugified_title(title) == result
  end
end
