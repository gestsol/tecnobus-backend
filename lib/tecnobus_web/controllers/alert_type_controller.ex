defmodule TecnobusWeb.AlertTypeController do
  use TecnobusWeb, :controller

  alias Tecnobus.Events
  alias Tecnobus.Events.AlertType

  action_fallback TecnobusWeb.FallbackController

  def index(conn, _params) do
    alert_types = Events.list_alert_types()
    render(conn, "index.json", alert_types: alert_types)
  end

  def create(conn, %{"alert_type" => alert_type_params}) do
    with {:ok, %AlertType{} = alert_type} <- Events.create_alert_type(alert_type_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.alert_type_path(conn, :show, alert_type))
      |> render("show.json", alert_type: alert_type)
    end
  end

  def show(conn, %{"id" => id}) do
    alert_type = Events.get_alert_type!(id)
    render(conn, "show.json", alert_type: alert_type)
  end

  def update(conn, %{"id" => id, "alert_type" => alert_type_params}) do
    alert_type = Events.get_alert_type!(id)

    with {:ok, %AlertType{} = alert_type} <- Events.update_alert_type(alert_type, alert_type_params) do
      render(conn, "show.json", alert_type: alert_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    alert_type = Events.get_alert_type!(id)

    with {:ok, %AlertType{}} <- Events.delete_alert_type(alert_type) do
      send_resp(conn, :no_content, "")
    end
  end
end
