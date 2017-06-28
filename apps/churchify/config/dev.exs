use Mix.Config

# Configure your database
config :churchify, Churchify.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "churchify_dev",
  hostname: "localhost",
  pool_size: 10
