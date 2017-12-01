defmodule Tilex.Channel do
  use TilexWeb, :model

  @type t :: module

  alias Tilex.Post

  schema "channels" do
    field(:name, :string)
    field(:twitter_hashtag, :string)

    has_many(:posts, Post)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :twitter_hashtag])
    |> unique_constraint(:name)
    |> validate_required([:name, :twitter_hashtag])
  end

  def names_and_ids(query) do
    from(c in query, select: {c.name, c.id})
  end

  def alphabetized(query) do
    from(c in query, order_by: c.name)
  end
end
