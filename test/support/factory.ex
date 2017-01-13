defmodule Tilex.Factory do

  alias Tilex.{Channel, Post, Repo}
  import Ecto.Query

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
      slug: Post.generate_slug(),
    }
  end

  def build(factory_name, attributes) do
    build(factory_name) |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end

  defp find_first_or_build(:channel) do
    Repo.one(from(Channel, limit: 1)) || build(:channel)
  end
end
