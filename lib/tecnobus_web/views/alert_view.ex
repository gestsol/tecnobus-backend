defmodule TecnobusWeb.AlertView do
  use TecnobusWeb, :view
  alias TecnobusWeb.AlertView
  alias TecnobusWeb.AlertTypeView

  def render("index.json", %{alerts: alerts}) do
    %{data: render_many(alerts, AlertView, "alert.json")}
  end

  def render("show.json", %{alert: alert}) do
    %{data: render_one(alert, AlertView, "alert.json")}
  end

  def render("alert.json", %{alert: alert}) do
    %{
      id: alert.id,
      device: alert.device,
      datetime: alert.datetime,
      lat: alert.lat,
      lng: alert.lng,
      group: alert.group,
      alert_type_id: alert.alert_type_id,
      alert_type: (if Ecto.assoc_loaded?(alert.alert_type), do: render_one(alert.alert_type, AlertTypeView, "alert_type.json"), else: nil)
    }
  end
end
