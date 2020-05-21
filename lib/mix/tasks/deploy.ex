defmodule Mix.Tasks.Deploy do
  use Mix.Task

  @shortdoc "Deployment commands."
  @moduledoc """
    Deploys our environments.
  """

  @environments ~w(gigalixir)

  def run([env]) when env in @environments, do: do_run(env)
  def run(_), do: raise("Unsupported environment, try one of these: #{inspect(@environments)}")

  defp do_run(env) do
    System.cmd("git", ["push", env, "master"])
  end
end
