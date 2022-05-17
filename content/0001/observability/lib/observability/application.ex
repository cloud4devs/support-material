defmodule Observability.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Observability.PromEx,
      # Start the Ecto repository and replicas
      Observability.Repo,

      # Start the Telemetry supervisor
      ObservabilityWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Observability.PubSub},
      # Start the Endpoint (http/https)
      ObservabilityWeb.Endpoint,
      # Start a worker by calling: Observability.Worker.start_link(arg)
      # {Observability.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Observability.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObservabilityWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:observability, Oban)
  end
end
