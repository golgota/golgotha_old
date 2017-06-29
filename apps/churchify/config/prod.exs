use Mix.Config

# Configure your database
config :churchify, Churchify.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  database: "churchify_prod",
  url: System.get_env("DATABASE_URL")
