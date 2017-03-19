defmodule Tilex.Factory do

  alias Tilex.{Channel, Developer, Post, Repo}
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
      developer: find_first_or_build(:developer),
      slug: Post.generate_slug(),
    }
  end

  def build(:developer) do
    %Developer{
      email: "developer@hashrocket.com",
      username: "Ricky Rocketeer",
      google_id: "186823978541230597895"
    }
  end

  def build(factory_name, attributes) do
    build(factory_name) |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end

  def insert_list!(factory_name, count, attributes \\ []) do
    1..count
    |> Enum.each(fn(_i) ->
      Repo.insert! build(factory_name, attributes)
    end)
  end

  defp find_first_or_build(:channel) do
    Repo.one(from(Channel, limit: 1)) || build(:channel)
  end

  defp find_first_or_build(:developer) do
    Repo.one(from(Developer, limit: 1)) || build(:developer)
  end
end
