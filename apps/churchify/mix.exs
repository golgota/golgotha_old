defmodule Churchify.Mixfile do
  use Mix.Project

  def project do
    [app: :churchify,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: preferred_cli_env(),
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Churchify.Application, []},
     extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:phoenix, "~> 1.3.0-rc"},
      {:postgrex, ">= 0.0.0"},

      {:credo, "~> 0.7", only: [:dev, :test]},
      {:ex_machina, "~> 2.0"},
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"],
      "test.cover": &run_default_coverage/1,
      "test.cover.html": &run_html_coverage/1
    ]
  end

  defp preferred_cli_env do
    ["coveralls": :test,
     "coveralls.detail": :test,
     "coveralls.post": :test,
     "coveralls.html": :test]
  end

  defp run_default_coverage(args), do: run_coverage("coveralls", args)
  defp run_html_coverage(args), do: run_coverage("coveralls.html", args)
  defp run_coverage(task, args) do
    {_, res} = System.cmd "mix", [task, "--umbrella" | args],
                          into: IO.binstream(:stdio, :line),
                          env: [{"MIX_ENV", "test"}]

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
