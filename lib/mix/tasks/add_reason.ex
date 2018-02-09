defmodule Mix.Tasks.AddReason do
  use Mix.Task
  alias Mix.{Project}
  alias Tilex.{Channel, Repo}

  @shortdoc "Add a new channel"
  @moduledoc """
    This will add a new channel to our databases.
  """

  def run(_) do
    Application.ensure_all_started(Project.config()[:app])
    Repo.insert!(%Channel{name: "reasonml", twitter_hashtag: "reasonml"})
  end
end
