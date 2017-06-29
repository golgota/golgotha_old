use Mix.Config

# Configure your database
config :churchify, Churchify.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PG_USERNAME") || "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  hostname: System.get_env("PG_HOST") || "localhost",
  database: System.get_env("DATABASE_NAME") || "churchify_test",
  ownership_timeout: 10 * 60 * 1000,
  pool: Ecto.Adapters.SQL.Sandbox
