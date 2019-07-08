defmodule Tilex.Factory do
  alias Tilex.{Channel, Developer, Post, Repo}
  import Ecto.Query

  @type factory_name :: atom()

  def build(Channel) do
    name = channel_name()

    %Channel{
      name: name,
      twitter_hashtag: String.downcase(name)
    }
  end

  def build(:channel) do
    %Channel{
      name: "phoenix",
      twitter_hashtag: "phoenix"
    }
  end

  def build(:post) do
    %Post{
      title: "A post",
      body: "A body",
      channel: find_first_or_build(:channel),
      developer: find_first_or_build(:developer),
      slug: Post.generate_slug()
    }
  end

  def build(:developer) do
    %Developer{
      email: "developer@hashrocket.com",
      username: "Ricky Rocketeer"
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end

  def insert_list!(factory_name, count, attributes \\ []) do
    1..count
    |> Enum.each(fn _i ->
      Repo.insert!(build(factory_name, attributes))
    end)
  end

  @spec attrs(factory_name) :: %{}
  def attrs(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Map.from_struct()
  end

  defp find_first_or_build(:channel) do
    Repo.one(from(Channel, limit: 1)) || build(:channel)
  end

  defp find_first_or_build(:developer) do
    Repo.one(from(Developer, limit: 1)) || build(:developer)
  end

  defp channel_name, do: Enum.random(~w(Elixir Erlang Phoenix Ruby Rails React ReactNative))
end
