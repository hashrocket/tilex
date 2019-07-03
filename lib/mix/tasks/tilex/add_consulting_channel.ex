defmodule Mix.Tasks.Tilex.AddConsultingChannel do
  use Mix.Task

  @shortdoc "Add consulting channel"
  @moduledoc """
    Adds a consulting channel.
  """

  def run(_) do
    Mix.Task.run("app.start")
    Tilex.Repo.insert!(%Tilex.Channel{name: "consulting", twitter_hashtag: "consulting"})
  end
end
