defmodule Observability.Accounts.Users do
  @moduledoc """
  Provides repository to Clients module
  """
  import Ecto.Query, warn: false

  require Logger

  alias Observability.Accounts.User
  alias Observability.Repo

  def insert(attrs) do
    attrs
    |> User.changeset()
    |> Repo.insert()
  end

  def get(id) do
    Repo.get!(User, id)
  end
end
