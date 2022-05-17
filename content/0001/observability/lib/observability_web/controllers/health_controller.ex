defmodule ObservabilityWeb.HealthController do
  use ObservabilityWeb, :controller
  alias ObservabilityWeb.HealthView

  action_fallback ObservabilityWeb.FallbackController

  # def show(conn, _params) do
  #   conn
  #   |> put_status(:ok)
  #   |> put_view(HealthView)
  #   |> render("show.json", response: :ok)
  # end

  def show(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(HealthView)
    |> render("show.json", response: :bad_request)
  end
end
