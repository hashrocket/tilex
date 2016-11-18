# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :today_i_learned,
  ecto_repos: [TodayILearned.Repo]

# Configures the endpoint
config :today_i_learned, TodayILearned.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mdTtrt4Y4JrtiTv63NepUe4fs1iSt23VfzKpnXm6mawKl6wN8jEfLfIf2HbyMeKe",
  render_errors: [view: TodayILearned.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TodayILearned.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ecto_factory, repo: TodayILearned.Repo
config :ecto_factory, factories: [
  post: TodayILearned.Post,

  post_with_defaults: { TodayILearned.Post, [
    title: "How To Program",
    body: "Ask lots of questions and think outside of the box!"
  ] }
]
