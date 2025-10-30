defmodule Tilex.MCP.NewPost do
  @moduledoc """
  Create a new TIL ("Today I Learned") post.

  TIL is a place for sharing something you've learned today with others.
  """

  use Anubis.Server.Component, type: :tool

  import Ecto.Query, only: [from: 2]

  alias Anubis.Server.Response
  alias Ecto.Changeset
  alias Tilex.Blog.Channel
  alias Tilex.Blog.Developer
  alias Tilex.Blog.Developer
  alias Tilex.Blog.Post
  alias Tilex.Repo
  alias Tilex.Repo
  alias TilexWeb.Endpoint
  alias TilexWeb.Router.Helpers, as: Routes

  schema do
    field :title, :string,
      required: true,
      description: "Max #{Post.title_max_chars()} chars."

    field :body, :string,
      required: true,
      description: "Max #{Post.body_max_words()} words in a Markdown format."

    field :channel, :string,
      required: true,
      description: "Channel is given by the list_channels MCP resource from this same server."
  end

  @impl true
  def execute(input, frame) do
    resp = Response.tool()

    resp =
      with {:ok, current_user} <- get_current_user(frame),
           {:ok, channel} <- get_channel(input),
           {:ok, %Post{} = post} <- create_til_post(current_user, channel, input) do
        url = Routes.post_url(Endpoint, :edit, post)

        Response.resource_link(resp, url, "til-post",
          description: "Open this link in order to review the TIL and publish it!"
        )
      else
        {:error, %Changeset{} = cs} ->
          Response.error(resp, changeset_errors(cs))

        {:error, reason} ->
          Response.error(resp, "ERROR => #{reason}")
      end

    {:reply, resp, frame}
  end

  defp get_current_user(frame) do
    headers = Enum.into(frame.transport.req_headers, %{})
    signed_token = headers["x-api-key"]

    with "" <> _ <- signed_token,
         {:ok, mcp_api_key} <- Developer.verify_mcp_api_key(TilexWeb.Endpoint, signed_token) do
      Repo.one(from d in Developer, where: d.mcp_api_key == ^mcp_api_key)
    else
      _ -> nil
    end
    |> case do
      nil -> {:error, "User is not authenticated to create TILs"}
      %Developer{} = user -> {:ok, user}
    end
  end

  defp get_channel(%{channel: channel}) do
    query = from(c in Channel, where: c.name == ^channel)

    case Repo.one(query) do
      nil -> {:error, "Channel does not exist: #{channel}"}
      %Channel{} = channel -> {:ok, channel}
    end
  end

  defp create_til_post(%Developer{} = current_user, channel, %{title: title, body: body}) do
    attrs = %{
      developer_id: current_user.id,
      title: title,
      body: body,
      channel_id: channel.id
    }

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
    |> Enum.flat_map(fn {field, errors} ->
      Enum.map(errors, &"#{Phoenix.Naming.humanize(field)} #{&1}")
    end)
    |> Enum.join("\n")
  end
end
