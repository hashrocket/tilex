defmodule Tilex.Developer do
  use Tilex.Web, :model

  schema "developers" do
    field :email, :string
    field :username, :string
    field :google_id, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :google_id])
    |> validate_required([:email, :username, :google_id])
  end

  def create_developer(attrs) do
    changeset(%Tilex.Developer{}, attrs)
  end
end
