defmodule Tilex.MCP.NewPost do
  @moduledoc """
  Create a new TIL ("Today I Learned") post.

  TIL is a place for sharing something you've learned today with others.
  """

  use Hermes.Server.Component, type: :tool

  alias Hermes.Server.Response
  alias Tilex.Blog.Developer
  alias Tilex.Blog.Post
  alias TilexWeb.Endpoint
  alias TilexWeb.Router.Helpers, as: Routes

  schema do
    field :title, :string,
      required: true,
      description: "Max #{Post.title_max_chars()} chars."

    field :body, :string,
      required: true,
      description:
        "Max #{Post.body_max_words()} words in a Markdown format."
  end

  def execute(input, frame) do
    current_user = frame.assigns.current_user
    resp = Response.tool()

    resp =
      case create_til_post(current_user, input) do
        {:ok, %Post{} = post} ->
          url = Routes.post_url(Endpoint, :show, post)
          Response.resource_link(resp, url, "til-post", description: "Link to the TIL post preview")

        {:error, reason} ->
          Response.error(resp, "ERROR => #{reason}")
      end

    {:reply, resp, frame}
  end

  defp create_til_post(nil, _input) do
    {:error, "User is not authenticated to create TILs"}
  end

  defp create_til_post(%Developer{} = current_user, %{title: title, body: body}) do
    {:ok, %Post{title: title, body: body, slug: "foo-bar"}}
  end
end
