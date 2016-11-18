use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :today_i_learned, TodayILearned.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :hound, driver: "chrome_driver", port: 9515, app_port: 4001

# Configure your database
config :today_i_learned, TodayILearned.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "today_i_learned_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
