# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kickstart,
  ecto_repos: [Kickstart.Repo]

# Configures the endpoint
config :kickstart, Kickstart.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7CsFEA+nQ92qsmVpuH90qlEI8PMzfyQx1iYJiVaWFMgvkc+46N/+VMWM9RYhd0PO",
  render_errors: [view: Kickstart.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kickstart.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
