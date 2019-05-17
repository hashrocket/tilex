defmodule TilexWeb.Router do
  use TilexWeb, :router

  @auth_controller Application.get_env(:tilex, :auth_controller)

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Tilex.Plug.BasicAuth)
    plug(Tilex.Plug.FormatInjector)
  end

  pipeline :browser_auth do
    plug(Guardian.Plug.Pipeline,
      module: Tilex.Auth.Guardian,
      error_handler: Tilex.Auth.ErrorHandler
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :rate_limit do
    plug(Tilex.Plug.RateLimiter)
  end

  scope "/api", TilexWeb do
    pipe_through([:api])

    get("/developer_posts.json", Api.DeveloperPostController, :index)
  end

  get("/rss", TilexWeb.FeedController, :index)
  get("/pixel", TilexWeb.PixelController, :index)

  scope "/", TilexWeb do
    pipe_through([:browser, :rate_limit])

    post("/posts/:slug/like.json", PostController, :like)
    post("/posts/:slug/unlike.json", PostController, :unlike)
  end

  scope "/", TilexWeb do
    pipe_through([:browser, :browser_auth])

    get("/admin", @auth_controller, :index)
    delete("/auth/logout", AuthController, :delete)
    get("/auth/:provider", AuthController, :request)
    get("/auth/:provider/callback", AuthController, :callback)
    post("/auth/:provider/callback", AuthController, :callback)

    get("/statistics", StatsController, :index)
    get("/developer/statistics", StatsController, :developer)

    get("/sitemap.xml", SitemapController, :index)
    get("/manifest.json", WebManifestController, :index)
    get("/random", PostController, :random)
    get("/authors/:name", DeveloperController, :show)
    get("/profile/edit", DeveloperController, :edit)
    put("/profile/edit", DeveloperController, :update)

    get("/", PostController, :index)
    resources("/posts", PostController, param: "titled_slug")
    # catch-any route should be last
    get("/:name", ChannelController, :show)
  end
end
