defmodule Tilex.Mixfile do
  use Mix.Project

  def project do
    [app: :tilex,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Tilex, []},
     applications: [
       :appsignal,
       :cowboy,
       :extwitter,
       :gettext,
       :logger,
       :phoenix,
       :phoenix_ecto,
       :phoenix_html,
       :phoenix_pubsub,
       :postgrex,
       :timex,
       :ueberauth_google,
     ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal, "~> 1.0"},
      {:basic_auth, "~> 2.1"},
      {:cowboy, "~> 1.0"},
      {:earmark, github: "pragdave/earmark", ref: "2bc9051"},
      {:extwitter, "~> 0.8"},
      {:gettext, "~> 0.13"},
      {:guardian, "~> 0.14"},
      {:html_sanitize_ex, "~> 1.2"},
      {:phoenix, "~> 1.2.4"},
      {:phoenix_ecto, "~> 3.1"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.0"},
      {:ueberauth_google, "~> 0.5"},
      {:wallaby, "~> 0.17.0", only: :test},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
