defmodule Tilex.Factory do
  alias Tilex.Repo

  def build(:channel) do
    %Tilex.Channel{
      name: "phoenix",
      twitter_hashtag: "phoenix"
    }
  end

  def build(factory_name, attributes) do
    build(factory_name) |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end
end
