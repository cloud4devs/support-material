defmodule Observability.Notifications.Emails do
  require Logger
  alias Observability.Notifications.Workers.Sender

  def send_email(user) do
    %{name: user.name}
    |> Sender.new()
    |> Oban.insert()

    {:ok, user}
  end
end
