import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/observability start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :observability, ObservabilityWeb.Endpoint, server: true
end

if config_env() == :prod do
  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :observability, Observability.Repo,
    username: "postgres",
    password: "postgres",
    database: "observability_dev",
    hostname: "localhost",
    pool_size: 10

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base = "Ud7N82/OijPB2AJ/7K39kBwF5lzh6OaeHvoXEX07SsmdF3WRU265twSCjIDoMHP2"

  config :observability, ObservabilityWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  config :observability, Observability.PromEx,
    manual_metrics_start_delay: :no_delay,
    drop_metrics_group: [],
    grafana: [
      host: "http://localhost:3000",
      auth_token:
        "eyJrIjoiTWRDM0N2eW1YNjNKSThDSXM5emE0c2s2OU1xVUJVcTMiLCJuIjoib2JzZXJ2YWJpbGl0eSIsImlkIjoxfQ==",
      upload_dashboards_on_start: true,
      folder_name: "observability",
      annotate_app_lifecycle: true
    ],
    prometheus_datasource_id: "Prometheus",
    prometheus_default_selected_interval: "30s"

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :observability, Observability.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
