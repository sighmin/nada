use Mix.Config

# Run a server during test for feature tests
config :nada, NadaWeb.Endpoint,
  http: [port: 4002],
  server: true

# Run tests isolated in a Postgresql sandbox
config :nada, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :nada, Nada.Repo,
  username: "postgres",
  password: "postgres",
  database: "nada_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
