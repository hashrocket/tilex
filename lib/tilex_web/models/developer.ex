defmodule Tilex.Developer do
  use TilexWeb, :model

  @type t :: module

  alias Tilex.{Developer, Post}

  schema "developers" do
    field(:email, :string)
    field(:username, :string)
    field(:google_id, :string)
    field(:twitter_handle, :string)
    field(:admin, :boolean)
    field(:editor, :string)

    has_many(:posts, Post)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :google_id, :twitter_handle, :editor])
    |> validate_required([:email, :username, :google_id])
    |> clean_twitter_handle
  end

  def find_or_create(repo, attrs) do
    email = Map.get(attrs, :email)

    case repo.get_by(Developer, email: email) do
      %Developer{} = developer ->
        {:ok, developer}

      _ ->
        %Developer{}
        |> changeset(attrs)
        |> repo.insert()
    end
  end

  def twitter_handle(%Developer{twitter_handle: twitter_handle}) do
    twitter_handle || Application.get_env(:tilex, :default_twitter_handle)
  end

  def format_username(name) when is_binary(name) do
    name
    |> String.downcase()
    |> String.replace(" ", "")
  end

  defp clean_twitter_handle(changeset) do
    twitter_handle = get_change(changeset, :twitter_handle)

    if twitter_handle do
      clean_twitter_handle = String.replace_leading(twitter_handle, "@", "")

      changeset
      |> put_change(:twitter_handle, clean_twitter_handle)
    else
      changeset
    end
  end

  defimpl Phoenix.Param, for: Developer do
    def to_param(%{username: username}) do
      username
    end
  end
end
