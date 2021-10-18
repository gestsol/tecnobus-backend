defmodule TecnobusWeb.AlertTypeControllerTest do
  use TecnobusWeb.ConnCase

  alias Tecnobus.Events
  alias Tecnobus.Events.AlertType

  @create_attrs %{
    code: "some code",
    name: "some name"
  }
  @update_attrs %{
    code: "some updated code",
    name: "some updated name"
  }
  @invalid_attrs %{code: nil, name: nil}

  def fixture(:alert_type) do
    {:ok, alert_type} = Events.create_alert_type(@create_attrs)
    alert_type
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all alert_types", %{conn: conn} do
      conn = get(conn, Routes.alert_type_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create alert_type" do
    test "renders alert_type when data is valid", %{conn: conn} do
      conn = post(conn, Routes.alert_type_path(conn, :create), alert_type: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.alert_type_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some code",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.alert_type_path(conn, :create), alert_type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update alert_type" do
    setup [:create_alert_type]

    test "renders alert_type when data is valid", %{conn: conn, alert_type: %AlertType{id: id} = alert_type} do
      conn = put(conn, Routes.alert_type_path(conn, :update, alert_type), alert_type: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.alert_type_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some updated code",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, alert_type: alert_type} do
      conn = put(conn, Routes.alert_type_path(conn, :update, alert_type), alert_type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete alert_type" do
    setup [:create_alert_type]

    test "deletes chosen alert_type", %{conn: conn, alert_type: alert_type} do
      conn = delete(conn, Routes.alert_type_path(conn, :delete, alert_type))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.alert_type_path(conn, :show, alert_type))
      end
    end
  end

  defp create_alert_type(_) do
    alert_type = fixture(:alert_type)
    %{alert_type: alert_type}
  end
end
