defmodule ObservabilityWeb.UserView do
  use ObservabilityWeb, :view

  def render("show.json", %{user: user}) do
    %{id: user.id, name: user.name, is_active: user.is_active, inserted_at: user.inserted_at}
  end
end
