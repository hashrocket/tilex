defmodule TilexWeb.Schema.PostTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Tilex.Repo

  object :post do
    field(:title, :string)
    field(:body, :string)
    field(:slug, :string)
    field(:likes, :integer)
    field(:developer, :developer, resolve: assoc(:developer))
    field(:channel, :channel, resolve: assoc(:channel))
  end

  object :developer do
    field(:email, :string)
    field(:username, :string)
    field(:twitter_handle, :string)
  end

  object :channel do
    field(:name, :string)
    field(:twitter_hashtag, :string)
  end
end
