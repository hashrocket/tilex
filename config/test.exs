import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tilex, Tilex.Repo,
  username: System.get_env("POSTGRES_USER", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", ""),
  hostname: "localhost",
  database: "tilex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 50,
  timeout: 30_000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tilex, TilexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Wu16BxBM2nOO3e0YEIcPs14fVuVXRZPew1CpIBVoG59QvlDRNKmuR/Pjh2LYE7bf",
  server: true

# In test we don't send emails.
config :tilex, Tilex.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :tilex, :sandbox, Ecto.Adapters.SQL.Sandbox

config :tilex, :organization_name, "Hashrocket"
config :tilex, :canonical_domain, "https://til.hashrocket.com"
config :tilex, :default_twitter_handle, "hashrocket"
config :tilex, :hosted_domain, "hashrocket.com"
config :tilex, :auth_controller, Test.AuthController
config :tilex, :slack_notifier, Test.Notifications.Notifiers.Slack
config :tilex, :twitter_notifier, Test.Notifications.Notifiers.Twitter
config :tilex, :webhook_notifier, Test.Notifications.Notifiers.Webhook
config :tilex, :date_time_module, Tilex.DateTimeMock
config :tilex, :date_display_tz, "America/Chicago"
config :tilex, :slack_endpoint, "https://slack.test.com/abc/123"
config :tilex, :webhook_url, "https://example.com/webhook"
config :tilex, :webhook_basic_auth, "user:password"

config :httpoison, timeout: 6000

config :wallaby,
  otp_app: :tilex,
  screenshot_dir: "/screenshots",
  screenshot_on_failure: true,
  chromedriver: [headless: System.get_env("HEADLESS", "true") == "true"]

config :tilex, :request_tracking, true

config :appsignal, :config, active: false
