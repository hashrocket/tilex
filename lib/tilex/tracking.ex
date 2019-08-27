defmodule Tilex.Tracking do
  alias Tilex.Repo
  alias Tilex.Request
  alias TilexWeb.Endpoint

  import Ecto.Query, only: [from: 2, subquery: 1]
  import Tilex.QueryHelpers, only: [between: 3, matches?: 2]

  @request_tracking Application.get_env(:tilex, :request_tracking, false)

  def track(conn) do
    spawn(fn ->
      if @request_tracking do
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
        request in subquery(requests),
        join: post in Tilex.Post,
        on: [slug: request.url_slug],
        order_by: [desc: request.view_count],
        limit: 10,
        select: %{
          title: post.title,
          url: request.url,
          view_count: request.view_count
        }
      )

    Repo.all(query)
  end
end
