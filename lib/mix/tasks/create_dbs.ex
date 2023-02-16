defmodule Mix.Tasks.CreateDbs do
    @moduledoc "Creates databases in ArangoDB. `create_dbs http://localhost:8529/`"
    @shortdoc "create_dbs db_url"

    use Mix.Task
    require HTTPoison

    @create_database_suffix "_api/database"

    @dbs ["db1"]

    @impl Mix.Task
    def run(_args) do

      url = String.last("db_url")
      # url = "#{@arango_url}/#{db_name}"
      headers = %{
        "Content-Type" => "application/json",
        "Authorization" => "Basic " <> Base.encode64("username:password")
      }
      body = Poison.encode!(%{})
      case HTTPoison.post(url, body, headers) do
        {:ok, %{status_code: 201}} ->
          Logger.info("Database created successfully.")
        {:ok, response} ->
          Logger.error("Unexpected response: #{inspect response}")
        {:error, error} ->
          Logger.error("Failed to create database: #{inspect error}")
      end
      # Mix.shell().info(Enum.join(args, " "))
    end
end
