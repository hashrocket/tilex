defmodule Tilex.DeveloperTest do
  use Tilex.ModelCase

  alias Tilex.Developer

  test "can format its username" do
    username = "Johnny Appleseed"
    result = "johnnyappleseed"
    assert Developer.format_username(username) == result
  end
end
