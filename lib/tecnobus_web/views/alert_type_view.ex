defmodule TecnobusWeb.AlertTypeView do
  use TecnobusWeb, :view
  alias TecnobusWeb.AlertTypeView

  def render("index.json", %{alert_types: alert_types}) do
    %{data: render_many(alert_types, AlertTypeView, "alert_type.json")}
  end

  def render("show.json", %{alert_type: alert_type}) do
    %{data: render_one(alert_type, AlertTypeView, "alert_type.json")}
  end

  def render("alert_type.json", %{alert_type: alert_type}) do
    %{id: alert_type.id,
      name: alert_type.name,
      code: alert_type.code}
  end
end
