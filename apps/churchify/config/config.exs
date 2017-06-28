use Mix.Config

config :churchify, ecto_repos: [Churchify.Repo]

import_config "#{Mix.env}.exs"
