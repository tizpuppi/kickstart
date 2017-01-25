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


config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [request_path: "/auth/github",
                                         callback_path: "/auth/github/callback",
                                         default_scope: "user,public_repo"]
    },
    facebook: {Ueberauth.Strategy.Facebook, [request_path: "/auth/facebook",
                                             callback_path: "/auth/facebook/callback",
                                             default_scope: "email,public_profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_APP_ID"),
  client_secret: System.get_env("FACEBOOK_APP_SECRET"),
  redirect_uri: System.get_env("FACEBOOK_REDIRECT_URI")

