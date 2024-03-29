defmodule Tilex.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: module

  alias Tilex.Blog.Developer
  alias Tilex.Blog.Channel
  alias Tilex.Blog.Post

  @body_max_words 200
  def body_max_words, do: @body_max_words

  @title_max_chars 50
  def title_max_chars, do: @title_max_chars

  @required_params ~w(body channel_id developer_id title)a
  @permitted_params @required_params ++ ~w(developer_id likes max_likes)a

  schema "posts" do
    field(:title, :string)
    field(:body, :string)
    field(:slug, :string)
    field(:likes, :integer, default: 1)
    field(:max_likes, :integer, default: 1)
    field(:tweeted_at, :utc_datetime)

    belongs_to(:channel, Channel)
    belongs_to(:developer, Developer)

    timestamps(type: :utc_datetime)
  end

  def slugified_title(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^A-Za-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end

  defp validate_length_of_body(changeset) do
    body = get_field(changeset, :body)
    validate_length_of_body(changeset, body)
  end

  defp validate_length_of_body(changeset, nil), do: changeset

  defp validate_length_of_body(changeset, body) do
    if length(String.split(body, ~r/\s+/)) > body_max_words() do
      add_error(changeset, :body, "should be at most #{body_max_words()} word(s)")
    else
      changeset
    end
  end

  def generate_slug do
    16
    |> :crypto.strong_rand_bytes()
    |> :base64.encode()
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "")
    |> String.slice(0, 10)
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params, @permitted_params)
    |> add_slug
    |> validate_required(@required_params)
    |> validate_length(:title, max: title_max_chars())
    |> validate_length_of_body
    |> validate_number(:likes, greater_than: 0)
    |> foreign_key_constraint(:channel_id)
    |> foreign_key_constraint(:developer_id)
  end

  defp add_slug(changeset) do
    case get_field(changeset, :slug) do
      nil ->
        generate_slug()
        |> (&put_change(changeset, :slug, &1)).()

      _ ->
        changeset
    end
  end

  defimpl Phoenix.Param, for: Post do
    def to_param(%{slug: slug, title: title}) do
      "#{slug}-#{Post.slugified_title(title)}"
    end
  end
end
