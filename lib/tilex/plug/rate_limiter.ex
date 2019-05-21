defmodule Tilex.Plug.RateLimiter do
  import Plug.Conn
  import Phoenix.Controller, only: [text: 2]

  alias Tilex.RateLimiter

  def init(default), do: default

  def call(conn, _default) do
    if RateLimiter.check(ip: conn.remote_ip) do
      conn
    else
      conn
      |> put_status(:too_many_requests)
      |> text("Don't mess with the space cowboys")
      |> halt()
    end
  end
end
