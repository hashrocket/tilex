defmodule TilexWeb.Api.DeveloperPostController do
  @moduledoc """
  This module implements a public API for querying Tilex data.
  """

  use TilexWeb, :controller
  alias Tilex.{Posts}

  @doc """
  This function allows external requesters to retrieve a developer's three most
  recent posts.
  """
  def index(conn, params) do
    posts = Posts.by_developer(params["username"], limit: 3)

    render(conn, "index.json", posts: posts)
  end
end
