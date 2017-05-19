defmodule Tilex.Liking do
  def like(slug) do
    post = Tilex.Repo.get_by!(Tilex.Post, slug: slug)
    likes = post.likes + 1
    like_changes = %{likes: likes, max_likes: Enum.max([likes, post.max_likes])}
    changeset = Tilex.Post.changeset(post, like_changes)
    Tilex.Repo.update!(changeset)
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
