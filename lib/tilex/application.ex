defmodule Tilex.Application do
  use Application

  def start(_type, _args) do
    children = [
      Tilex.Repo,
      TilexWeb.Endpoint,
      {Phoenix.PubSub, name: Tilex.PubSub},
      {Cachex, name: :tilex_cache},
      Tilex.Notifications,
      Tilex.RateLimiter,
      Tilex.Notifications.NotifiersSupervisor
    ]

    :telemetry.attach(
      "appsignal-ecto",
      [:tilex, :repo, :query],
      &Appsignal.Ecto.handle_event/4,
      nil
    )

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tilex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TilexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
