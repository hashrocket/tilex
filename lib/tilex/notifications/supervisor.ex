defmodule Tilex.Notifications.Supervisor do
  @slack_notifier Application.get_env(:tilex, :slack_notifier)

  use Supervisor

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    children = [
      @slack_notifier,
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
