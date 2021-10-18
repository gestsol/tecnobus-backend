defmodule TecnobusWeb.AlertControllerTest do
  use TecnobusWeb.ConnCase

  alias Tecnobus.Events
  alias Tecnobus.Events.Alert

  @create_attrs %{
    datetime: ~N[2010-04-17 14:00:00],
    device: "some device",
    group: "some group",
    lat: "some lat",
    lng: "some lng"
  }
  @update_attrs %{
    datetime: ~N[2011-05-18 15:01:01],
    device: "some updated device",
    group: "some updated group",
    lat: "some updated lat",
    lng: "some updated lng"
  }
  @invalid_attrs %{datetime: nil, device: nil, group: nil, lat: nil, lng: nil}

  def fixture(:alert) do
    {:ok, alert} = Events.create_alert(@create_attrs)
    alert
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all alerts", %{conn: conn} do
      conn = get(conn, Routes.alert_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create alert" do
    test "renders alert when data is valid", %{conn: conn} do
      conn = post(conn, Routes.alert_path(conn, :create), alert: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.alert_path(conn, :show, id))

      assert %{
               "id" => id,
               "datetime" => "2010-04-17T14:00:00",
               "device" => "some device",
               "group" => "some group",
               "lat" => "some lat",
               "lng" => "some lng"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.alert_path(conn, :create), alert: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update alert" do
    setup [:create_alert]

    test "renders alert when data is valid", %{conn: conn, alert: %Alert{id: id} = alert} do
      conn = put(conn, Routes.alert_path(conn, :update, alert), alert: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.alert_path(conn, :show, id))

      assert %{
               "id" => id,
               "datetime" => "2011-05-18T15:01:01",
               "device" => "some updated device",
               "group" => "some updated group",
               "lat" => "some updated lat",
               "lng" => "some updated lng"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, alert: alert} do
      conn = put(conn, Routes.alert_path(conn, :update, alert), alert: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete alert" do
    setup [:create_alert]

    test "deletes chosen alert", %{conn: conn, alert: alert} do
      conn = delete(conn, Routes.alert_path(conn, :delete, alert))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.alert_path(conn, :show, alert))
      end
    end
  end

  defp create_alert(_) do
    alert = fixture(:alert)
    %{alert: alert}
  end
end
