require Logger

defmodule Mix.Tasks.Tilex.Hdb do
  use Mix.Task

  @shortdoc "Replace development PostgreSQL DB with dump from a Heroku app's DB."

  @moduledoc """
  Run `mix tilex.hdb -a tilex` to copy all data from the production database to the
  development database.
  """

  def run(args) do
    parser =
      Optimus.new!(
        name: "tilex.hdb",
        description: @shortdoc,
        about: @moduledoc,
        options: [
          app: [
            short: "-a",
            long: "--app",
            help: "Source Heroku app name.",
            required: true,
            parser: :string
          ]
        ],
        flags: [
          force: [
            short: "-f",
            long: "--force",
            help: "Continue without user input.",
            default: false
          ]
        ]
      )

    parsed = Optimus.parse!(parser, args)

    if parsed.flags.force or confirm("This will drop your local database. Continue?") do
      replace_local_db_with_heroku_db(parsed.options.app)
    end
  end

  defp confirm(prompt) do
    input = IO.gets("#{prompt} [y/n] ")
    "y" == input |> String.trim() |> String.downcase()
  end

  defp tmpfile() do
    case System.cmd("mktemp", []) do
      {filename, 0} -> {:ok, String.trim(filename)}
      {out, status} -> {:error, {out, status}}
    end
  end

  defp fetch_heroku_dsn(heroku_app) do
    result =
      System.cmd("heroku", [
        "run",
        "-a",
        heroku_app,
        "--no-notify",
        "--no-tty",
        "-x",
        "sh -c 'echo $DATABASE_URL'"
      ])

    case result do
      {dsn, 0} -> {:ok, String.trim(dsn)}
      {out, status} -> {:error, {out, status}}
    end
  end

  @dsn_pattern ~r{^
    (?<type>.+?)
    ://
    (?<username>.+?)
    :
    (?<password>.*?)
    @
    (?<hostname>.+?)
    :
    (?<port>.+?)
    /
    (?<database>.+)
  $}x

  defp parse_dsn(dsn) do
    case Regex.named_captures(@dsn_pattern, dsn) do
      nil ->
        {:error, :nomatch}

      captures ->
        {:ok, captures |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)}
    end
  end

  defp pg_args(config, args) do
    List.foldl(
      [
        ["-U", config[:username]],
        ["-h", config[:hostname]],
        ["-p", config[:port]]
      ],
      args,
      fn
        [_, nil], acc -> acc
        [flag, val], acc -> [flag, val | acc]
      end
    ) ++ [config[:database]]
  end

  defp pg_env(config) do
    [{"PGPASSWORD", Keyword.get(config, :password, "")}]
  end

  defp pg_dump_to_file(config, filename) do
    args = pg_args(config, ["-f", filename, "--no-acl", "--no-owner"])

    case System.cmd("pg_dump", args, env: pg_env(config)) do
      {_, 0} -> :ok
      {out, status} -> {:error, {out, status}}
    end
  end

  defp psql_import(config, filename) do
    args = pg_args(config, ["-f", filename])

    case System.cmd("psql", args, env: pg_env(config)) do
      {_, 0} -> :ok
      {out, status} -> {:error, {out, status}}
    end
  end

  defp exit_with_error(msg) do
    Logger.error(msg)
    Process.exit(self(), :normal)
  end

  defp check_cmd_error(_cmd_label, :ok), do: :ok
  defp check_cmd_error(_cmd_label, {:ok, v}), do: v

  defp check_cmd_error(cmd_label, {:error, {output, status}}) do
    exit_with_error("`#{cmd_label}` failed with status #{status}\n\n#{output}")
  end

  defp replace_local_db_with_heroku_db(heroku_app) do
    tmp = check_cmd_error("mktemp", tmpfile())

    try do
      Logger.info("Dumping Heroku app `#{heroku_app}` DB to #{tmp}...")

      dsn = check_cmd_error("heroku run", fetch_heroku_dsn(heroku_app))

      config =
        case parse_dsn(dsn) do
          {:ok, config} ->
            config

          {:error, :nomatch} ->
            exit_with_error("Found invalid app DB DSN in Heroku: #{inspect(dsn)}")
        end

      check_cmd_error("pg_dump", pg_dump_to_file(config, tmp))

      Logger.info("Recreating local DB...")
      Mix.Task.run("ecto.drop")
      Mix.Task.run("ecto.create")

      Logger.info("Loading to local DB from #{tmp} ...")

      check_cmd_error("psql", psql_import(Tilex.Repo.config(), tmp))
    after
      File.rm!(tmp)
    end
  end
end
