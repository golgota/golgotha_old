defmodule Churchify.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: preferred_cli_env(),
     deps: deps()]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:credo, "~> 0.7", only: [:dev, :test]},
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
      "prod.setup": ["ecto.migrate", "run apps/churchify/priv/repo/seeds.exs"],
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
