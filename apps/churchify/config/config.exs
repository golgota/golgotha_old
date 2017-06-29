use Mix.Config

config :churchify,
  ecto_repos: [Churchify.Repo],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

import_config "#{Mix.env}.exs"
