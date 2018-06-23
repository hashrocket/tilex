defmodule TilexWeb.Api.DeveloperPostController do
  @moduledoc """
  This module implements a public API for querying Tilex data.
  """

  use TilexWeb, :controller
  alias Tilex.{Posts}

  @doc """
  This function allows external requesters to retrieve a developer's posts and
  supports a limit.
  """
  def index(conn, %{"username" => username, "limit" => limit} = params) do
    posts = Posts.by_developer(username, limit: limit)
    render_posts(conn, posts)
  end

  @doc """
  This function allows external requesters to retrieve all of a developer's
  posts.
  """
  def index(conn, %{"username" => username} = params) do
    posts = Posts.by_developer(username)
    render_posts(conn, posts)
  end

  defp render_posts(conn, posts) do
    render(conn, "index.json", posts: posts)
  end
end
