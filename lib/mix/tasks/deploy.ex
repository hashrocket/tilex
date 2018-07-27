defmodule Mix.Tasks.Deploy do
  use Mix.Task

  @shortdoc "Deployment commands."
  @moduledoc """
    Deploys our environments.
  """

  def run(["staging"]), do: do_run("staging")
  def run(["production"]), do: do_run("production")
  def run(_), do: raise("Unsupported environment")

  defp do_run(env) do
    System.cmd("git", ["fetch", "--tags"])
    System.cmd("git", ["tag", "-d", env])
    System.cmd("git", ["push", "origin", ":refs/tags/#{env}"])
    System.cmd("git", ["tag", env])
    System.cmd("git", ["push", "origin", "--tags"])

    System.cmd("git", ["push", env, "master"])
    System.cmd("heroku", ["run", "POOL_SIZE=2 mix ecto.migrate", "-r#{env}"])
    System.cmd("heroku", ["restart", "-r#{env}"])
  end
end
