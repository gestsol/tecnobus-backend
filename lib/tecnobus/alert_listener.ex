defmodule Tecnobus.AlertListener do
  alias Tecnobus.API.Alerts
  alias Tecnobus.API.Whatsapp
  alias Tecnobus.API.BodyHelper.AlertRequest
  alias Tecnobus.Events

  def process_centinela_alerts(minutes) do
    alerts = get_centinela_alerts(minutes)

    if length(alerts) > 0 do
      Task.async(fn ->
        send_whatsapp(alerts, "+58", "04121153914")
      end)

      alerts = Enum.map(alerts, &format_alert/1)

      Task.async(fn ->
        Enum.each(alerts, &Events.create_alert/1)
      end)
    end
  end

  def get_centinela_alerts(minutes) do
    terid = Alerts.get_devices_by_group(36) |> Enum.map(fn d -> d["terid"] end)

    {starttime, endtime} = get_start_end_dates(minutes)

    body = %AlertRequest{
      terid: terid,
      # Codigos de alarmas, se solicitan todas.
      type: [15, 36, 38, 51, 60, 61, 62, 162, 164],
      starttime: starttime,
      endtime: endtime
    }

    Alerts.get_alerts(body)
    |> append_alert_name()
  end

  def get_start_end_dates(offset) when is_integer(offset) do
    now = Timex.now("America/Santiago")

    endtime = now |> format_datetime()

    starttime =
      now
      # 10 minutos antes de la hora actual.
      |> Timex.subtract(Timex.Duration.from_minutes(offset))
      |> format_datetime()

    {starttime, endtime}
  end

  def format_datetime(d) do
    str = d |> DateTime.to_naive() |> NaiveDateTime.to_string()
    # ELiminar milisegundos para que quede en este formato:
    # YYYY-MM-DD HH:mm:ss
    Regex.replace(~r/\.[^.]*$/, str, "")
  end

  def append_alert_name([]) do
    []
  end

  def append_alert_name(alerts) do
    types = Events.list_alert_types()

    Enum.map(alerts, fn a ->
      type = Integer.to_string(a["type"], 10)
      alert_DB = Enum.find(types, &(&1.code === type))
      alert_name = alert_DB |> Map.get(:name)

      Map.merge(a, %{"alert_name" => alert_name, "alert_type_id" => alert_DB.id})
    end)
  end

  def send_whatsapp(alerts, code, phone) do
    message = assemble_multiple_messages(alerts)
    Whatsapp.send(code, phone, message)
  end

  def assemble_message(alert) do
    "*#{alert["alert_name"]}*. Vehículo: #{alert["terid"]}. Velocidad: #{alert["speed"]}Km/h. hora: #{alert["time"]}"
  end

  def assemble_multiple_messages(alerts) do
    Enum.reduce(alerts, "", fn alert, acc ->
      msg = assemble_message(alert)
      acc <> "                                                            " <> msg
    end)
  end

  def format_alert(alert) do
    %{
      "datetime" => alert["time"],
      "device" => alert["terid"],
      "group" => "Centinela",
      "lat" => alert["gpslat"],
      "lng" => alert["gpslng"],
      "alert_type_id" => alert["alert_type_id"]
    }
  end
end
