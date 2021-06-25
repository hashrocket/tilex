defmodule Tilex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tilex,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tilex.Application, []},
      extra_applications: [:logger, :appsignal]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal_phoenix, "~> 2.0"},
      {:cachex, "~> 3.1"},
      {:cors_plug, "~> 2.0"},
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false},
      {:earmark, "1.4.4"},
      {:ecto_sql, "~> 3.4"},
      {:excoveralls, "~> 0.14.1", only: :test},
      {:extwitter, "~> 0.8"},
      {:floki, "~> 0.31.0"},
      {:gettext, "~> 0.13"},
      {:guardian, "~> 2.0"},
      {:hackney, "1.17.4"},
      {:html_sanitize_ex, "~> 1.2"},
      {:jason, "~> 1.0"},
      {:optimus, "~> 0.2.0"},
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.3.0"},
      {:phoenix_html, "~> 2.14.3"},
      {:phoenix_live_reload, "~> 1.1", only: :dev},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.1"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1"},
      {:tzdata, "~> 1.1.0"},
      {:ueberauth_google, "~> 0.5"},
      {:wallaby, "~> 0.28.0", [runtime: false, only: :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
