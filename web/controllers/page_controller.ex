defmodule TodayILearned.PageController do
  use TodayILearned.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
