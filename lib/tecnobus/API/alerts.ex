defmodule Tecnobus.API.Alerts do
  alias Tecnobus.API.BodyHelper.AlertRequest
  use Tesla, only: [:post, :get]

  plug Tesla.Middleware.Timeout, timeout: 120_000
  plug Tesla.Middleware.BaseUrl, "http://181.212.4.22:12056/api/v1/basic"
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.JSON

  def get_auth_key() do
    try do
      {:ok, response} = get("/key?username=wit&password=wit3004..")

      Map.get(response, :body)
      |> Map.get("data")
      |> Map.get("key")

    rescue
      e in MatchError ->
        {:error, reason} = Map.get(e, :term)
        raise("ERROR AL HACER SOLICITUD A LA API DE ALARMAS. RAZÓN: #{reason}")
    end

  end

  def get_groups do
    do_request("get", "/groups")
  end

  def get_devices do
    do_request("get", "/devices")
  end

  def get_devices_by_group(group_id) do
    get_devices()
    |> Enum.filter(fn d -> d["groupid"] === group_id end)
  end

  def get_device_by_terid(terid) do
    get_devices()
    |> Enum.find(fn d -> d["terid"] === terid end)
  end

  def get_alerts(body = %AlertRequest{}) do
    do_request("post", "/alarm/detail", Map.from_struct(body))
  end

  def do_request("post", endpoint, body) do
    auth_key = get_auth_key()

    post(endpoint, Map.put(body, "key", auth_key))
    |> extract_response_data()
  end

  def do_request("get", endpoint) do
    auth_key = get_auth_key()

    get("#{endpoint}?key=#{auth_key}")
    |> extract_response_data()
  end

  def extract_response_data(api_call) do
    {:ok, response} = api_call

    Map.get(response, :body)
    |> Map.get("data")
  end
end
