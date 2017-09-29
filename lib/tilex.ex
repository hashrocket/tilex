defmodule Tilex do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Tilex.Repo, []),
      # Start the endpoint when the application starts
      supervisor(TilexWeb.Endpoint, []),
      worker(Cachex, [:tilex_cache, []]),
      worker(Tilex.Notifications, []),
      supervisor(Tilex.Notifications.NotifiersSupervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tilex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
