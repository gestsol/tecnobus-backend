defmodule TecnobusWeb.AlertController do
  use TecnobusWeb, :controller

  alias Tecnobus.Events
  alias Tecnobus.Events.Alert

  action_fallback TecnobusWeb.FallbackController

  def index(conn, _params) do
    alerts = Events.list_alerts()
    render(conn, "index.json", alerts: alerts)
  end

  def create(conn, %{"alert" => alert_params}) do
    with {:ok, %Alert{} = alert} <- Events.create_alert(alert_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.alert_path(conn, :show, alert))
      |> render("show.json", alert: alert)
    end
  end

  def show(conn, %{"id" => id}) do
    alert = Events.get_alert!(id)
    render(conn, "show.json", alert: alert)
  end

  def update(conn, %{"id" => id, "alert" => alert_params}) do
    alert = Events.get_alert!(id)

    with {:ok, %Alert{} = alert} <- Events.update_alert(alert, alert_params) do
      render(conn, "show.json", alert: alert)
    end
  end

  def delete(conn, %{"id" => id}) do
    alert = Events.get_alert!(id)

    with {:ok, %Alert{}} <- Events.delete_alert(alert) do
      send_resp(conn, :no_content, "")
    end
  end
end
