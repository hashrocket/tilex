defmodule TilexWeb.Router do
  use TilexWeb, :router

  @auth_controller Application.compile_env(:tilex, :auth_controller)
  @basic_auth Application.compile_env(:tilex, :basic_auth)

  defdelegate basic_auth(conn, options \\ []), to: Plug.BasicAuth

  pipeline :browser do
    plug Tilex.Plug.RequestRejector
    plug Tilex.Plug.SetCanonicalUrl
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TilexWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    if @basic_auth do
      plug :basic_auth, @basic_auth
    end

    plug Tilex.Plug.FormatInjector
  end

  pipeline :browser_auth do
    plug Guardian.Plug.Pipeline,
      module: Tilex.Auth.Guardian,
      error_handler: Tilex.Auth.ErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :api do
    plug Tilex.Plug.RequestRejector
    plug :accepts, ["json"]
  end

  pipeline :rate_limit do
    plug Tilex.Plug.RateLimiter
  end

  scope "/api", TilexWeb do
    pipe_through [:api]

    get "/developer_posts.json", Api.DeveloperPostController, :index
    get "/recent_posts.json", Api.PostController, :index, as: :api_post
  end

  get "/rss", TilexWeb.FeedController, :index
  get "/pixel", TilexWeb.PixelController, :index

  scope "/", TilexWeb do
    pipe_through [:browser, :rate_limit]

    post "/posts/:slug/like.json", PostController, :like
    post "/posts/:slug/unlike.json", PostController, :unlike
  end

  scope "/", TilexWeb do
    pipe_through [:browser, :browser_auth]

    get "/admin", @auth_controller, :index
    delete "/auth/logout", AuthController, :delete
    get "/auth/:provider", AuthController, :request
    get "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :callback

    get "/statistics", StatsController, :index
    get "/developer/statistics", StatsController, :developer

    get "/sitemap.xml", SitemapController, :index
    get "/manifest.json", WebManifestController, :index
    get "/random", PostController, :random
    get "/authors/:name", DeveloperController, :show
    get "/profile/edit", DeveloperController, :edit
    put "/profile/edit", DeveloperController, :update
    post "/profile/api_key/generate", DeveloperController, :generate_api_key

    get "/", PostController, :index
    resources "/posts", PostController, param: "titled_slug"
    # catch-any route should be last
    get "/:channel/random", ChannelController, :random_by_channel
    get "/:name", ChannelController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TilexWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  forward "/mcp",
          Hermes.Server.Transport.StreamableHTTP.Plug,
          server: Tilex.MCP.Server
end
