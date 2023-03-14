defmodule Mix.Tasks.Elixango.Create do

  use Mix.Task
  import Mix.Elixango

  @adapter Ecto.Adapters.Elixango


  @shortdoc "Creates the repository storage"

  @switches [
    quiet: :boolean,
    repo: [:string, :keep],
    no_compile: :boolean,
    no_deps_check: :boolean
  ]

  @aliases [
    r: :repo,
    q: :quiet
  ]

  @moduledoc """
  Create the storage for the given repository.

  The repositories to create are the ones specified under the
  `:ecto_repos` option in the current app configuration. However,
  if the `-r` option is given, it replaces the `:ecto_repos` config.

  Since Ecto tasks can only be executed once, if you need to create
  multiple repositories, set `:ecto_repos` accordingly or pass the `-r`
  flag multiple times.

  ## Examples

      $ mix ecto.create
      $ mix ecto.create -r Custom.Repo

  ## Command line options

    * `-r`, `--repo` - the repo to create
    * `--quiet` - do not log output
  """

  @impl true
  def run(args) do
    repos = parse_repo(args)
    {:ok, _started} = Application.ensure_all_started(:arangox)
    {opts, _} = OptionParser.parse! args, strict: @switches, aliases: @aliases

    Enum.each repos, fn repo ->
      IO.inspect repo, label: "repo"
      ensure_repo(repo, args)
      # ensure_implements(repo.__adapter__, Ecto.Adapter.Storage,
      #                                     "create storage for #{inspect repo}")

      case create_db(repo.__adapter__, repo.config) do
        :ok ->
          unless opts[:quiet] do
            Mix.shell().info "The database for #{inspect repo} has been created"
          end
        :pass ->
          unless opts[:quiet] do
            Mix.shell().info "Pass, #{inspect repo} is not have #{@adapter} adapter."
          end
        {:error, :already_up} ->
          unless opts[:quiet] do
            Mix.shell().info "The database for #{inspect repo} has already been created"
          end
        {:error, term} when is_binary(term) ->
          Mix.raise "The database for #{inspect repo} couldn't be created: #{term}"
        {:error, term} ->
          Mix.raise "The database for #{inspect repo} couldn't be created: #{inspect term}"
      end
    end
  end

  def create_db(@adapter, config) do
    with {:ok, conn} <- create_system_conn(config) do
      with {:ok, :available} <- check_availability(conn) do
        case create_new_database(conn, %{name: config[:database]}) do
          {:ok, :created} -> :ok
          {:ok, :exist} -> {:error, :already_up}
          e -> e
        end
      end
    end
  end
  def create_db(_adapter, _config) do
    :pass
  end
end
