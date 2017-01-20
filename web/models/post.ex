defmodule Tilex.Post do
  use Tilex.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :likes, :integer, default: 1

    belongs_to :channel, Tilex.Channel

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :channel_id, :likes])
    |> validate_required([:title, :body, :channel_id, :likes])
    |> validate_length(:title, max: 50)
    |> validate_length_of_body
    |> validate_number(:likes, greater_than: 0)
    |> add_slug
  end

  defp validate_length_of_body(changeset) do
    body = get_field(changeset, :body)
    validate_length_of_body(changeset, body)
  end

  defp validate_length_of_body(changeset, nil), do: changeset

  defp validate_length_of_body(changeset, body) do
    if length(String.split(body, ~r/\s+/)) > 200 do
      add_error(changeset, :body, "should be at most 200 word(s)")
    else
      changeset
    end
  end

  def generate_slug do
    :base64.encode(:crypto.strong_rand_bytes(16))
    |> String.replace(~r/[^A-Za-z0-9]/, "")
    |> String.slice(0, 10)
    |> String.downcase
  end

  defp add_slug(changeset) do
    unless get_field(changeset, :slug) do
      generate_slug()
      |> (&put_change(changeset, :slug, &1)).()
    else
      changeset
    end
  end
end
