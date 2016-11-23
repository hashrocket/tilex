defmodule TodayILearned.PostController do
  use TodayILearned.Web, :controller

  alias TodayILearned.Post

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post)
  end
end
