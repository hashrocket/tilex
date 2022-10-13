defmodule Tilex.Blog.DeveloperTest do
  use Tilex.DataCase, async: true

  alias Tilex.Blog.Developer

  test "can format its username" do
    username = "Johnny Appleseed"
    result = "johnnyappleseed"
    assert Developer.format_username(username) == result
  end

  test "changeset strips leading @ symbol from twitter handle" do
    changeset = Developer.changeset(%Developer{}, %{twitter_handle: "@tilex"})
    assert Ecto.Changeset.get_field(changeset, :twitter_handle) == "tilex"
  end
end
