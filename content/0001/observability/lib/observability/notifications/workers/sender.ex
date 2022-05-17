defmodule Observability.Notifications.Workers.Sender do
  use Oban.Worker, queue: :emails

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"name" => name} = _args}) do
    Logger.info("Sending email to user #{name}")
    :ok
  end
end
