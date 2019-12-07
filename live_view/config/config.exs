# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :live_view, LiveViewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NqICxQuEkmFHFHyq1B7s8J1vjDH0NliuBo9/5vwNotDR95CHPKXHVIx6gZM+Xx2K",
  render_errors: [view: LiveViewWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveView.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "lh33hwm18RBDF7VgymL4HOVQinJ4hkWT"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :storage, ecto_repos: [Storage.Repo]

config :storage, Storage.Repo,
  database: "storage_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5433"
