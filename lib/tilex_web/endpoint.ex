defmodule TilexWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :tilex

  if Application.get_env(:tilex, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  socket "/socket", TilexWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :tilex, gzip: false,
    only: ~w(assets
      apple-touch-icon-120x120.png
      apple-touch-icon.png
      apple-touch-icon-precomposed.png
      css
      favicon.ico
      favicon.png
      fonts
      hashrocket-logo.png
      images
      js
      robots.txt
    )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_tilex_key",
    signing_salt: "PSNTTaPr"

  use Appsignal.Phoenix
  plug TilexWeb.Router
end
