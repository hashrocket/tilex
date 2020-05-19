import Config

config :tilex, TilexWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]

import_config "env_vars.exs"
