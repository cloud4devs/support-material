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
  config :observability, Observability.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :observability, ObservabilityWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :observability, Observability.PromEx,
    manual_metrics_start_delay: :no_delay,
    drop_metrics_group: [],
    grafana: [
      host: System.fetch_env!("GRAFANA_URL"),
      auth_token: System.fetch_env!("GRAFANA_AUTH_TOKEN"),
      upload_dashboards_on_start: true,
      folder_name: System.fetch_env!("GRAFANA_DASHBOARD_FOLDER_NAME"),
      annotate_app_lifecycle: true
    ],
    prometheus_datasource_id: System.fetch_env!("PROMETHEUS_DATA_SOURCE_ID"),
    prometheus_default_selected_interval:
      System.fetch_env!("PROMETHEUS_DEFAULT_SELECTED_INTERVAL")
end
