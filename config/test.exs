use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tilex, Tilex.Endpoint,
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
  pool: Ecto.Adapters.SQL.Sandbox
