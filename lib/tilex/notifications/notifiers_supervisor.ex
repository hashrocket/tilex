defmodule Tilex.Notifications.NotifiersSupervisor do
  @slack_notifier Application.get_env(:tilex, :slack_notifier)
  @twitter_notifier Application.get_env(:tilex, :twitter_notifier)

  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  def children do
    [
      @slack_notifier,
      @twitter_notifier,
    ]
  end
end
