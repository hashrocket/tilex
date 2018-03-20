defmodule TilexWeb.Resolvers.Post do
  alias Tilex.Posts

  def resolved_posts(_root, %{developer_username: username, limit: limit}, _info) do
    {:ok, Posts.by_developer(username, limit: limit)}
  end

  def resolved_posts(_root, %{page: page}, _info) do
    {:ok, Posts.all(page)}
  end
end
