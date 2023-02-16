defmodule Elixango.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixango,
      version: "0.1.0",
      elixir: "~> 1.14",
      package: package(),
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package() do
    [
      # # This option is only needed when you don't want to use the OTP application name
      # name: "elixango",
      # These are the default files included in the package
      # files: ~w(lib .formatter.exs mix.exs README* lib),
      licenses: [],
      links: %{},
      description: "it is arango db wrapper",
    ]
  end


  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Elixango.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:arangox, "~> 0.5.4"},
      {:phoenix, "~> 1.6.6"},
      {:velocy, "~> 0.1"},
      {:ecto, "~> 3.7.1"},
      {:ecto_sql, "~> 3.4"},
      {:timex, "~> 3.7.6"},
      {:httpoison, "~> 2.0"},
      {:mint, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
