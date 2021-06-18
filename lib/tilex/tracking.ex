defmodule Tilex.Tracking do
  alias Tilex.Repo
  alias Tilex.Request
  alias TilexWeb.Endpoint

  import Ecto.Query, only: [from: 2, subquery: 1]
  import Tilex.QueryHelpers, only: [between: 3, matches?: 2]

  def track(conn) do
    spawn(fn ->
      if request_tracking() do
        with [referer | _] <- Plug.Conn.get_req_header(conn, "referer") do
          page = String.replace(referer, Endpoint.url(), "")
          Ecto.Adapters.SQL.query!(Repo, "insert into requests (page) values ($1);", [page])
        end
      end
    end)
  end

  def most_viewed_posts(start_date, end_date) do
    requests =
      from(
        req in Request,
        group_by: req.page,
        where: matches?(req.page, "/posts/"),
        where: not matches?(req.page, "/posts/.+/edit$"),
        where: between(req.request_time, ^start_date, ^end_date),
        order_by: [desc: count(req.page)],
        select: %{
          url: req.page,
          view_count: count(req.page),
          url_slug: fragment("substring(page from ?)", "/posts/(.*?)-")
        }
      )

    query =
      from(
        req in subquery(requests),
        join: post in Tilex.Post,
        on: [slug: req.url_slug],
        order_by: [desc: req.view_count],
        limit: 10,
        select: %{
          title: post.title,
          url: req.url,
          view_count: req.view_count
        }
      )

    Repo.all(query)
  end

  def total_page_views(start_date, end_date) do
    query =
      from(
        req in Request,
        where: between(req.request_time, ^start_date, ^end_date),
        select: count(req.page)
      )

    Repo.one(query)
  end

  defp request_tracking(), do: Application.get_env(:tilex, :request_tracking, false)
end
