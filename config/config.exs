# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :betwise,
  ecto_repos: [Betwise.Repo]

# Configures the endpoint
config :betwise, BetwiseWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: BetwiseWeb.ErrorHTML, json: BetwiseWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Betwise.PubSub,
  live_view: [signing_salt: "EgSLHJvN"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :betwise, Betwise.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config :betwise, Betwise.Mailer,
#   adapter: Swoosh.Adapters.SMTP,
#   server: "smtp.gmail.com",
#   port: 587,
#   username: "",
#   password: "",
#   tls: true




config :swoosh, local: true
# config :swoosh, :adapter, Swoosh.Adapters.SMTP

config :betwise, Betwise.Mailer,
  # adapter: Swoosh.Adapters.SMTP,
  relay: "Swoosh.Adapters.SMTP",
  server: "smtp.gmail.com",
  port: 587,
  username: "haron.korir@gmail.com",
  password: "",
  tls: true,
  ssl: false,
  otp_app: :betwise,
  debug: true

# config :swoosh, Swoosh.Adapters.SMTP,
#   adapter: Swoosh.Adapters.Local,
#   server: "smtp.gmail.com",
#   port: 587,
#   username: "",
#   password: "",
#   tls: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
