# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :nada, NadaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JqgFRz9YZqhsXXMLkLQnM+qe9tKyqSKHvbthgiaV0F/q3kuO6Aj2MqSAi8R2f82N",
  render_errors: [view: NadaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nada.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure email
config :nada, Nada.Mailer,
  adapter: Bamboo.LocalAdapter

# Configure file storage
config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: Map.fetch!(System.get_env(), "AWS_REGION")

# Configure Aws adapter
config :nada, Aws,
  adapter: Aws.Live

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
