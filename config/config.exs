# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gmax,
  ecto_repos: [Gmax.Repo]

# Configures the endpoint
config :gmax, GmaxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ahP+6GCNVE7c8XOQzSSvpARMcvGi3IgtBE0HAgTtlK03JMiCMbxY8mpO5TgJMrn3",
  render_errors: [view: GmaxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gmax.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger,
  backends: [{LoggerFileBackend, :file}],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :goth,
  json: "priv/config/google_creds.json" |> File.read!()

config :google_apis,
  oauth_client: "1071165484835-0pkq0e9gflc5lbbgajftouecan1jnm93.apps.googleusercontent.com",
  oauth_secret: "4yH8ANl62Vgi-hopilUoLkKf"

# Configure OAuth2
config :oauth2,
  serializers: %{
    "application/json" => Jason
  }

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
