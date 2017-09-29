use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tilex, TilexWeb.Endpoint,
  http: [port: 4001],
  server: true

config :tilex, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tilex, Tilex.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "tilex_test",
  hostname: "localhost",
  username: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :tilex, :page_size, 5
config :tilex, :auth_controller, Test.AuthController
config :tilex, :slack_notifier, Test.Notifications.Notifiers.Slack
config :tilex, :twitter_notifier, Test.Notifications.Notifiers.Twitter
config :tilex, :organization_name, "Hashrocket"
config :tilex, :canonical_domain, "https://til.hashrocket.com"
config :tilex, :default_twitter_handle, "hashrocket"

config :tilex, :async_feature_test, (System.get_env("ASYNC_FEATURE_TEST") == "yes")

config :httpoison, timeout: 6000

config :wallaby,
  driver: Wallaby.Experimental.Chrome,
  hackney_options: [timeout: :infinity, recv_timeout: :infinity],
  chrome: [
    headless: true
  ],
  screenshot_on_failure: true

