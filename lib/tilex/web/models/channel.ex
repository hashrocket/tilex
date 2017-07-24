defmodule Tilex.Channel do
  use Tilex.Web, :model

  schema "channels" do
    field :name, :string
    field :twitter_hashtag, :string

    has_many :posts, Tilex.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :twitter_hashtag])
    |> unique_constraint(:name)
    |> validate_required([:name, :twitter_hashtag])
  end

  def names_and_ids(query) do
    from c in query, select: {c.name, c.id}
  end

  def alphabetized(query) do
    from c in query, order_by: c.name
  end
end
