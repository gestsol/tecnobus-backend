# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tecnobus,
  ecto_repos: [Tecnobus.Repo]

# Configures the endpoint
config :tecnobus, TecnobusWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "++o5J9S+8FK99K8hgfRDkx1maZsf4faLi5manHW8fs+54Dcco+zP2Em9rDtUhl90",
  render_errors: [view: TecnobusWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Tecnobus.PubSub,
  live_view: [signing_salt: "t2Konjni"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Hackney for api calls with tesla
config :tesla, adapter: Tesla.Adapter.Hackney, recv_timeout: 120_000


config :tecnobus, Tecnobus.Scheduler,
  jobs: [
    process_alerts: [
      schedule: "/10 * * * *",
      task: {Tecnobus.AlertListener, :process_centinela_alerts, [10]}
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
