use Mix.Config

# Configure your database
config :churchify, Churchify.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "churchify_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
