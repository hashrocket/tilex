defmodule Tilex do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      Tilex.Repo,
      # Start the endpoint when the application starts
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

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tilex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
