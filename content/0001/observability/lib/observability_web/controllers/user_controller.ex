defmodule ObservabilityWeb.UserController do
  use ObservabilityWeb, :controller
  require Logger
  alias ObservabilityWeb.UserView

  action_fallback ObservabilityWeb.FallbackController

  alias Observability.Accounts

  def create(conn, params) do
    with {:ok, user} <- Accounts.create_user(params) do
      Logger.info("created user #{inspect(user)}")

      conn
      |> put_status(:ok)
      |> put_view(UserView)
      |> render("show.json", user: user)
    end
  end
end
