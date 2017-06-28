# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :churchify_web,
  namespace: Churchify.Web,
  ecto_repos: [Churchify.Repo]

# Configures the endpoint
config :churchify_web, Churchify.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tn0eZZr56FsC1BdBmQt8y5UzmUFDd2aQx0/ZnY/NgPW0ZZiboK6bDJK0GUOujslH",
  render_errors: [view: Churchify.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Churchify.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :churchify_web, :generators,
  context_app: :churchify

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
