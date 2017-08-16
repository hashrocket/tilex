defmodule Tilex.Liking do

  @moduledoc """
    Provides functions for liking and unliking a post.
  """

  def like(slug) do
    post = Tilex.Repo.get_by!(Tilex.Post, slug: slug)
    likes = post.likes + 1
    max_likes = Enum.max([likes, post.max_likes])
    max_likes_changed = max_likes != post.max_likes
    like_changes = %{likes: likes, max_likes: max_likes}
    changeset = Tilex.Post.changeset(post, like_changes)
    post = Tilex.Repo.update!(changeset)

    Tilex.Integrations.notify_of_awards(post, max_likes_changed)

    likes
  end

  def unlike(slug) do
    post = Tilex.Repo.get_by!(Tilex.Post, slug: slug)
    likes = post.likes - 1
    like_changes = %{likes: likes}
    changeset = Tilex.Post.changeset(post, like_changes)
    Tilex.Repo.update!(changeset)
    likes
  end
end
