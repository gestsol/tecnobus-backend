defmodule Tecnobus.EventsTest do
  use Tecnobus.DataCase

  alias Tecnobus.Events

  describe "alert_types" do
    alias Tecnobus.Events.AlertType

    @valid_attrs %{code: "some code", name: "some name"}
    @update_attrs %{code: "some updated code", name: "some updated name"}
    @invalid_attrs %{code: nil, name: nil}

    def alert_type_fixture(attrs \\ %{}) do
      {:ok, alert_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_alert_type()

      alert_type
    end

    test "list_alert_types/0 returns all alert_types" do
      alert_type = alert_type_fixture()
      assert Events.list_alert_types() == [alert_type]
    end

    test "get_alert_type!/1 returns the alert_type with given id" do
      alert_type = alert_type_fixture()
      assert Events.get_alert_type!(alert_type.id) == alert_type
    end

    test "create_alert_type/1 with valid data creates a alert_type" do
      assert {:ok, %AlertType{} = alert_type} = Events.create_alert_type(@valid_attrs)
      assert alert_type.code == "some code"
      assert alert_type.name == "some name"
    end

    test "create_alert_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_alert_type(@invalid_attrs)
    end

    test "update_alert_type/2 with valid data updates the alert_type" do
      alert_type = alert_type_fixture()
      assert {:ok, %AlertType{} = alert_type} = Events.update_alert_type(alert_type, @update_attrs)
      assert alert_type.code == "some updated code"
      assert alert_type.name == "some updated name"
    end

    test "update_alert_type/2 with invalid data returns error changeset" do
      alert_type = alert_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_alert_type(alert_type, @invalid_attrs)
      assert alert_type == Events.get_alert_type!(alert_type.id)
    end

    test "delete_alert_type/1 deletes the alert_type" do
      alert_type = alert_type_fixture()
      assert {:ok, %AlertType{}} = Events.delete_alert_type(alert_type)
      assert_raise Ecto.NoResultsError, fn -> Events.get_alert_type!(alert_type.id) end
    end

    test "change_alert_type/1 returns a alert_type changeset" do
      alert_type = alert_type_fixture()
      assert %Ecto.Changeset{} = Events.change_alert_type(alert_type)
    end
  end

  describe "alerts" do
    alias Tecnobus.Events.Alert

    @valid_attrs %{datetime: ~N[2010-04-17 14:00:00], device: "some device", group: "some group", lat: "some lat", lng: "some lng"}
    @update_attrs %{datetime: ~N[2011-05-18 15:01:01], device: "some updated device", group: "some updated group", lat: "some updated lat", lng: "some updated lng"}
    @invalid_attrs %{datetime: nil, device: nil, group: nil, lat: nil, lng: nil}

    def alert_fixture(attrs \\ %{}) do
      {:ok, alert} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_alert()

      alert
    end

    test "list_alerts/0 returns all alerts" do
      alert = alert_fixture()
      assert Events.list_alerts() == [alert]
    end

    test "get_alert!/1 returns the alert with given id" do
      alert = alert_fixture()
      assert Events.get_alert!(alert.id) == alert
    end

    test "create_alert/1 with valid data creates a alert" do
      assert {:ok, %Alert{} = alert} = Events.create_alert(@valid_attrs)
      assert alert.datetime == ~N[2010-04-17 14:00:00]
      assert alert.device == "some device"
      assert alert.group == "some group"
      assert alert.lat == "some lat"
      assert alert.lng == "some lng"
    end

    test "create_alert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_alert(@invalid_attrs)
    end

    test "update_alert/2 with valid data updates the alert" do
      alert = alert_fixture()
      assert {:ok, %Alert{} = alert} = Events.update_alert(alert, @update_attrs)
      assert alert.datetime == ~N[2011-05-18 15:01:01]
      assert alert.device == "some updated device"
      assert alert.group == "some updated group"
      assert alert.lat == "some updated lat"
      assert alert.lng == "some updated lng"
    end

    test "update_alert/2 with invalid data returns error changeset" do
      alert = alert_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_alert(alert, @invalid_attrs)
      assert alert == Events.get_alert!(alert.id)
    end

    test "delete_alert/1 deletes the alert" do
      alert = alert_fixture()
      assert {:ok, %Alert{}} = Events.delete_alert(alert)
      assert_raise Ecto.NoResultsError, fn -> Events.get_alert!(alert.id) end
    end

    test "change_alert/1 returns a alert changeset" do
      alert = alert_fixture()
      assert %Ecto.Changeset{} = Events.change_alert(alert)
    end
  end
end
