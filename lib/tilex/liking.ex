defmodule Tilex.Liking do
  alias Tilex.{Notifications, Post, Repo}

  def like(slug) do
    post = Repo.get_by!(Post, slug: slug)
    likes = post.likes + 1
    max_likes = Enum.max([likes, post.max_likes])
    max_likes_changed = max_likes != post.max_likes
    like_changes = %{likes: likes, max_likes: max_likes}
    changeset = Post.changeset(post, like_changes)
    post = Repo.update!(changeset)

    Notifications.post_liked(post, max_likes_changed)

    likes
  end

  def unlike(slug) do
    post = Repo.get_by!(Post, slug: slug)
    likes = post.likes - 1
    like_changes = %{likes: likes}
    changeset = Post.changeset(post, like_changes)
    Repo.update!(changeset)
    likes
  end
end
