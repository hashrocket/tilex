defmodule Tilex.Notifications.NotifiersSupervisor do
  use Supervisor

  def start_link([]) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  def children do
    [
      slack_notifier(),
      twitter_notifier()
    ]
  end

  defp slack_notifier, do: Application.get_env(:tilex, :slack_notifier)
  defp twitter_notifier, do: Application.get_env(:tilex, :twitter_notifier)
end
