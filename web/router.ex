defmodule Tilex.Router do
  use Tilex.Web, :router

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

    get "/admin", AuthController, :index
    get "/auth/:provider", AuthController, :request
    get "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :callback
    delete "/auth/logout", AuthController, :delete

    get "/statistics", StatsController, :index

    get "/:name", ChannelController, :show
    get "/authors/:name", DeveloperController, :show

    get "/", PostController, :index
    resources "/posts", PostController, only: [:index, :show, :new, :create], param: "titled_slug"
  end
end
