use Mix.Config

# Run a server during test for feature tests
config :nada, NadaWeb.Endpoint,
  http: [port: 4002],
  server: true

# Run tests isolated in a Postgresql sandbox
config :nada, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure feature test driver
config :wallaby,
  driver: Wallaby.Experimental.Chrome

# Configure email
#config :nada, Nada.Mailer,
  #adapter: Bamboo.TestAdapter
