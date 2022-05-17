defmodule ObservabilityWeb.HealthView do
  use ObservabilityWeb, :view

  def render("show.json", %{response: status}) do
    %{status: status}
  end
end
