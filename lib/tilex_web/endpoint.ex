defmodule TilexWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :tilex
  use Appsignal.Phoenix

  if sandbox = Application.compile_env(:tilex, :sandbox) do
    plug(Phoenix.Ecto.SQL.Sandbox, sandbox: sandbox)
  end

  socket("/socket", TilexWeb.UserSocket, websocket: true)

  @cors_origin Application.compile_env(:tilex, :cors_origin)

  if @cors_origin do
    origin = String.split(@cors_origin, [",", " "], trim: true)
    plug(CORSPlug, origin: origin)
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_tilex_key",
    signing_salt: "PSNTTaPr"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :tilex,
    gzip: true,
    headers: [{"access-control-allow-origin", "*"}],
    only: ~w(
      assets
      apple-touch-icon-120x120.png
      apple-touch-icon.png
      apple-touch-icon-precomposed.png
      css
      favicon.ico
      favicon.png
      fonts
      images
      js
      robots.txt
    )
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :tilex
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Logger
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug TilexWeb.Router
end
