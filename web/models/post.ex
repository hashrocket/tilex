defmodule Tilex.Post do
  use Tilex.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string

    belongs_to :channel, Tilex.Channel

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :channel_id])
    |> validate_required([:title, :body, :channel_id])
    |> validate_length(:title, max: 50)
  end
end
