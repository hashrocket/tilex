defmodule Mix.Tasks.Ecto.Twiki do
  use Mix.Task

  alias Ecto.{Migrator}
  alias Mix.{Ecto, Project}

  @shortdoc "Ecto Migration: Up, Down, Up"

  @moduledoc """
    This will migrate the latest Ecto migration, roll it back, and then
    migrate it again. This is an easy way to ensure that migrations can go
    up and down.
  """

  def run(args) do
    Application.ensure_all_started(Project.config[:app])

    repos = Ecto.parse_repo(args)

    twiki(repos)
  end

  defp twiki(repo) when is_atom(repo) do
    migration_dir =
      repo
      |> Ecto.source_repo_priv
      |> Path.absname
      |> Path.join("migrations")

    count = down_count(repo, migration_dir)

    Enum.each([:up, :down, :up], fn(direction) ->
      migrate(direction, repo, migration_dir, [step: count])
    end)
  end

  defp twiki([repo]) do
    twiki(repo)
  end

  defp twiki([_repo | _more_repos] = repos) do
    Mix.shell.info """
      Ecto.Twiki only supports migrating a single repo.
      However, we found multiple repos: #{inspect repos}
    """
  end

  defp migrate(direction, _repo, _migration_dir, [step: 0]) do
    Mix.shell.info "Already #{direction}"
    []
  end

  defp migrate(direction, repo, migration_dir, opts) do
    Mix.shell.info "Migrating #{direction}"
    Migrator.run(repo, migration_dir, direction, opts)
  end

  defp down_count(repo, migration_dir) do
    direction_count(:down, repo, migration_dir)
  end

  defp direction_count(direction, repo, migration_dir) do
    repo
    |> Migrator.migrations(migration_dir)
    |> Enum.filter(fn({status, _, _}) -> status == direction end)
    |> Enum.count
  end
end
