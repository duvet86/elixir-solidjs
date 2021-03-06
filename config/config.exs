# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_app,
  ecto_repos: [Domain.Repo]

# Configures the endpoint
config :elixir_app, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iH0ZiWCgUcNxqWpjJ7b98qltrvO5Feq5ykwl/pA8B9WFf6R7bTHKrlvaEEwWe2S5",
  render_errors: [view: Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Domain.PubSub,
  live_view: [signing_salt: "y7ckX0qS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
