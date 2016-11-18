defmodule TodayILearned.PostController do
  use TodayILearned.Web, :controller

  alias TodayILearned.Post

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end
end
