defmodule Tecnobus.AlertListener do
  alias Tecnobus.API.Alerts
  alias Tecnobus.API.Whatsapp
  alias Tecnobus.API.BodyHelper.AlertRequest
  alias Tecnobus.Events

  # Telefonos a los que se enviaran las alertas por whatsapp
  @phones [
    "+56950906625",
    "+56947518114",
    "+584121153914",
    "+56982334220",
    "+56962187191",
    "+56936509791"
  ]

  # Funcion para ser ejecutada en un job. Cada ciertos minutos
  # se obtienen las alertas de la api externa, se envian por whatsapp
  # y se guardan en nuestra base de datos.
  def process_centinela_alerts(minutes) do
    alerts = get_centinela_alerts(minutes)

    IO.puts("++++++++++++++++ ALERTAS +++++++++++++++++++")
    IO.inspect(alerts)

    if length(alerts) > 0 do
      alerts = Enum.map(alerts, &format_alert/1)

      created_alerts =
        Enum.map(alerts, fn alert ->
          case Events.create_alert(alert) do
            {:ok, _created_alert} -> alert
            {:error, error} ->
              IO.warn("ERROR AL INSERTAR ALERTA EN BASE DE DATOS. VER EL OUTPUT ABAJO:")
              IO.inspect(%{"error" => error})
              nil
          end
        end)
        |> Enum.reject(fn a -> is_nil(a) end)

      send_whatsapp(created_alerts, @phones)
    end
  end

  def get_centinela_alerts(minutes) do
    # Las alertas se solicitan especificando los terid's de los dispositivos
    # Nota: terid es un campo de la API de las alarmas que sirve como identificador de cada device.
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
    |> append_alert_name_and_device_id()
  end

  # El parametro de offset es la diferencia en minutos que queremos que exista
  # entre starttime y endtime. endtime siempre sera la hora actual.
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

  def append_alert_name_and_device_id([]) do
    []
  end

  # Agrega a las alertas el nombre de la alerta y el device_id,
  # en este caso el campo device_id se refiere al campo carlicence de la API externa.
  # Este campo es el que se guardara en nuestra base de datos en la tabla "Alerts"
  # en el campo "device"
  def append_alert_name_and_device_id(alerts) do
    types = Events.list_alert_types()

    Enum.map(alerts, fn a ->
      type = Integer.to_string(a["type"], 10)
      alert_DB = Enum.find(types, &(&1.code === type))
      alert_name = alert_DB |> Map.get(:name)
      # device_id sera el campo "carlicence" de los devices obtenido de la API de alarmas.
      device_id = Alerts.get_device_by_terid(a["terid"]) |> Map.get("carlicence")

      Map.merge(a, %{
        "alert_name" => alert_name,
        "alert_type_id" => alert_DB.id,
        "device_id" => device_id
      })
    end)
  end

  def send_whatsapp(alerts, phone) when is_bitstring(phone) do
    message = assemble_multiple_messages(alerts)
    Whatsapp.send(phone, message)
  end

  def send_whatsapp(alerts, phone) when is_list(phone) do
    message = assemble_multiple_messages(alerts)

    Enum.each(phone, fn p ->
      Whatsapp.send(p, message)
    end)
  end

  def assemble_message(alert) do
    "*#{alert["alert_name"]}*. Vehículo: #{alert["device"]}. Velocidad: #{alert["speed"]}Km/h. hora: #{alert["datetime"]}. Coordenadas: #{alert["lat"]},#{alert["lng"]}"
  end

  def assemble_multiple_messages(alerts) do
    Enum.reduce(alerts, "", fn alert, acc ->
      msg = assemble_message(alert)
      acc <> msg <> "                                                            "
    end)
  end

  # Crea el formato requerido de alerta para guardar en nuestra DB.
  def format_alert(alert) do
    %{
      "datetime" => alert["time"],
      "device" => alert["device_id"],
      "group" => "Centinela",
      "lat" => alert["gpslat"],
      "lng" => alert["gpslng"],
      "alert_type_id" => alert["alert_type_id"],
      "alert_name" => alert["alert_name"],
      "speed" => alert["speed"]
    }
  end
end
