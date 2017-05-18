defmodule Tilex.Router do
  use Tilex.Web, :router

  @auth_controller Application.get_env(:tilex, :auth_controller)

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Tilex.Plug.BasicAuth
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Tilex do
    pipe_through [:browser, :browser_auth]

    get "/admin", @auth_controller, :index
    delete "/auth/logout", AuthController, :delete
    get "/auth/:provider", AuthController, :request
    get "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :callback

    get "/statistics", StatsController, :index

    get "/:name", ChannelController, :show
    get "/authors/:name", DeveloperController, :show

    get "/", PostController, :index
    resources "/posts", PostController, param: "titled_slug"
    post "/posts/:id/like.json", PostController, :like
  end
end
