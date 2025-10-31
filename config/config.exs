# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# General application configuration
config :tilex, ecto_repos: [Tilex.Repo]

# Configures the endpoint
config :tilex, TilexWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    view: TilexWeb.ErrorView,
    accepts: ~w(html json),
    root_layout: {TilexWeb.LayoutView, :error},
    layout: false
  ],
  pubsub_server: Tilex.PubSub,
  live_view: [signing_salt: "by2pBeEk"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :tilex, Tilex.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Provide reasonable default for configuration options
config :tilex, :page_size, 5
config :tilex, :auth_controller, AuthController
config :tilex, :slack_notifier, Tilex.Notifications.Notifiers.Slack
config :tilex, :twitter_notifier, Tilex.Notifications.Notifiers.Twitter
config :tilex, :webhook_notifier, Tilex.Notifications.Notifiers.Webhook
config :tilex, :organization_name, System.get_env("ORGANIZATION_NAME")
config :tilex, :canonical_domain, System.get_env("CANONICAL_DOMAIN")
config :tilex, :default_twitter_handle, System.get_env("DEFAULT_TWITTER_HANDLE")
config :tilex, :cors_origin, System.get_env("CORS_ORIGIN")
config :tilex, :hosted_domain, System.get_env("HOSTED_DOMAIN")
config :tilex, :guest_author_allowlist, System.get_env("GUEST_AUTHOR_ALLOWLIST")
config :tilex, :date_display_tz, System.get_env("DATE_DISPLAY_TZ")
config :tilex, :imgur_client_id, System.get_env("IMGUR_CLIENT_ID")
config :tilex, :slack_endpoint, "https://hooks.slack.com#{System.get_env("slack_post_endpoint")}"
config :tilex, :banner_image_source, System.get_env("BANNER_IMAGE_SOURCE")
config :tilex, :banner_image_link, System.get_env("BANNER_IMAGE_LINK")
config :tilex, :banner_image_alt, System.get_env("BANNER_IMAGE_ALT")
config :tilex, :webhook_url, System.get_env("WEBHOOK_URL")
config :tilex, :webhook_basic_auth, System.get_env("WEBHOOK_BASIC_AUTH")

config :tilex,
       :rate_limiter_requests_per_time_period,
       System.get_env("RATE_LIMIT_REQUESTS_PER_TIME_PERIOD") || 5

config :tilex,
       :rate_limiter_time_period_minutes,
       System.get_env("RATE_LIMIT_TIME_PERIOD_MINUTES") || 1

config :tilex,
       :rate_limiter_cleanup_interval,
       # every 10 hours
       System.get_env("RATE_LIMIT_CLEANUP_INTERVAL") || 10 * 60 * 60_000

config :tilex, :date_time_module, DateTime

config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [
         approval_prompt: "force",
         access_type: "offline",
         default_scope: "email profile"
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :tilex, Tilex.Auth.Guardian,
  issuer: "tilex",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: %{
    "k" => "_AbBL082GKlPjoY9o-KM78PhyALavJRtZXOW7D-ZyqE",
    "kty" => "oct"
  }

config :tilex, Tilex.Notifications.Notifiers.Twitter,
  consumer_key: System.get_env("twitter_consumer_key"),
  consumer_secret: System.get_env("twitter_consumer_secret"),
  token: System.get_env("twitter_access_token"),
  token_secret: System.get_env("twitter_access_token_secret")

config :mime, :types, %{
  "text/event-stream" => ["stream"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
