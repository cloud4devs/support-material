defmodule Observability.Accounts do
  require Logger
  alias Observability.Notifications.Emails
  alias Observability.Accounts.{Users}

  def create_user(attrs) do
    with {:ok, user} <- Users.insert(attrs), do: Emails.send_email(user)
  end
end
