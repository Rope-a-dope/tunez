defmodule Tunez.MixProject do
  use Mix.Project

  def project do
    [
      app: :tunez,
      version: "0.1.0",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      aliases: aliases(),
      deps: deps(),
      listeners: [Phoenix.CodeReloader],
      compilers: [:phoenix_live_view] ++ Mix.compilers()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tunez.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ash_authentication_phoenix, "~> 2.17"},
      {:bcrypt_elixir, "~> 3.3"},
      {:picosat_elixir, "~> 0.2.3"},
      {:ash_authentication, "~> 4.14"},
      {:absinthe_phoenix, "~> 2.0"},
      {:ash_graphql, "~> 1.9"},
      {:open_api_spex, "~> 3.22"},
      {:ash_json_api, "~> 1.6"},
      {:ash_phoenix, "~> 2.3"},
      {:ash_postgres, "~> 2.10"},
      {:sourceror, "~> 1.12", only: [:dev, :test]},
      {:ash, "~> 3.29"},
      {:phoenix, "~> 1.8"},
      {:phoenix_ecto, "~> 4.7"},
      {:ecto_sql, "~> 3.14"},
      {:postgrex, "~> 0.22.2"},
      {:phoenix_html, "~> 4.3"},
      {:phoenix_live_reload, "~> 1.6", only: :dev},
      {:phoenix_live_view, "~> 1.2"},
      {:phoenix_live_dashboard, "~> 0.8.7"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.5.1", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.26"},
      {:req, "~> 0.6.2"},
      {:telemetry_metrics, "~> 1.1"},
      {:telemetry_poller, "~> 1.3"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:dns_cluster, "~> 0.2.0"},
      {:bandit, "~> 1.12"},
      {:igniter, "~> 0.8.2", only: [:dev]},
      {:lazy_html, "~> 0.1.11", only: :test},
      {:phoenix_test, "~> 0.11.1", only: :test, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ash.setup", "assets.setup", "assets.build", "run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      seed: [
        "run priv/repo/seeds/01-artists.exs",
        # "run priv/repo/seeds/02-albums.exs",
        # "run priv/repo/seeds/08-tracks.exs"
        "run priv/repo/seeds/admin.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind tunez", "esbuild tunez"],
      "assets.deploy": [
        "tailwind tunez --minify",
        "esbuild tunez --minify",
        "phx.digest"
      ]
    ]
  end
end
