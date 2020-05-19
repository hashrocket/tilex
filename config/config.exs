# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# General application configuration
config :tilex, ecto_repos: [Tilex.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the endpoint
config :tilex, TilexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mdTtrt4Y4JrtiTv63NepUe4fs1iSt23VfzKpnXm6mawKl6wN8jEfLfIf2HbyMeKe",
  render_errors: [view: TilexWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Tilex.PubSub,
  http: [protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]]

# Provide reasonable default for configuration options
config :tilex, :page_size, 5
config :tilex, :auth_controller, AuthController
config :tilex, :slack_notifier, Tilex.Notifications.Notifiers.Slack
config :tilex, :twitter_notifier, Tilex.Notifications.Notifiers.Twitter

config :tilex, :date_time_module, DateTime

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

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

config :tilex, Tilex.Auth.Guardian,
  issuer: "tilex",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: %{
    "k" => "_AbBL082GKlPjoY9o-KM78PhyALavJRtZXOW7D-ZyqE",
    "kty" => "oct"
  }

import_config "env_vars.exs"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
