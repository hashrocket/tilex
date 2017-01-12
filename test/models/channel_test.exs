defmodule Tilex.ChannelTest do
  use Tilex.ModelCase

  alias Tilex.{Channel, Factory}

  @valid_attrs %{name: "phoenix", twitter_hashtag: "phoenix"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Channel.changeset(%Channel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Channel.changeset(%Channel{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "it can return an alphabetized list of all records" do
    Enum.each(["zsh", "jekyll", "ada"], fn(name) ->
      Factory.insert!(:channel, name: name)
    end)

    query = Channel
    |> Channel.alphabetized
    channels = Repo.all(query)

    names = Enum.map(channels, fn(channel) ->
      channel.name
    end)

    assert names == ["ada", "jekyll", "zsh"]
  end

  test "changeset with non-unique channel name" do
    Tilex.Repo.insert(Channel.changeset(%Channel{}, @valid_attrs))
    {:error, changeset} = Tilex.Repo.insert(Channel.changeset(%Channel{}, @valid_attrs))

    refute changeset.valid?
  end
end
