defmodule Tilex.Blog.Developer do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: module

  alias Tilex.Blog.Developer
  alias Tilex.Blog.Post

  @mcp_api_key_name "mcp-api-key"
  @one_year :timer.hours(365 * 24)

  schema "developers" do
    field(:email, :string)
    field(:username, :string)
    field(:twitter_handle, :string)
    field(:admin, :boolean)
    field(:editor, :string)
    field(:mcp_api_key, :string)

    has_many(:posts, Post)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :twitter_handle, :editor])
    |> validate_required([:email, :username])
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

  def generate_mcp_api_key(endpoint) do
    mcp_api_key = Ecto.UUID.generate()

    %{
      mcp_api_key: mcp_api_key,
      signed_token: Phoenix.Token.sign(endpoint, @mcp_api_key_name, mcp_api_key)
    }
  end

  def verify_mcp_api_key(endpoint, signed_token) do
    Phoenix.Token.verify(endpoint, @mcp_api_key_name, signed_token, max_age: @one_year)
  end

  def mcp_api_key_changeset(developer, mcp_api_key) do
    developer
    |> cast(%{}, [])
    |> put_change(:mcp_api_key, mcp_api_key)
    |> validate_required([:mcp_api_key])
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
