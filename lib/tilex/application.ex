defmodule Tilex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Tilex.Repo,
      TilexWeb.Telemetry,
      {Phoenix.PubSub, name: Tilex.PubSub},
      TilexWeb.Endpoint,
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

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tilex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TilexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
