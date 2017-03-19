defmodule Tilex.Developer do
  use Tilex.Web, :model

  schema "developers" do
    field :email, :string
    field :username, :string
    field :google_id, :string

    has_many :posts, Tilex.Post

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :google_id])
    |> validate_required([:email, :username, :google_id])
  end

  def find_or_create(repo, attrs) do
    google_id = Map.get(attrs, :google_id)

    case repo.get_by(Tilex.Developer, google_id: google_id) do
      %Tilex.Developer{} = developer ->
        {:ok, developer}
      _ ->
        changeset(%Tilex.Developer{}, attrs)
        |> repo.insert()
    end
  end

  defimpl Phoenix.Param, for: Tilex.Developer do
    def to_param(%{username: username}) do
      username
    end
  end
end
