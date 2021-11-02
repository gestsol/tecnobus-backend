defmodule Tecnobus.API.Whatsapp do
  use Tesla, only: [:post, :get]

  # plug Tesla.Middleware.BaseUrl, "https://new-send-api-whatsapp.herokuapp.com"
  plug Tesla.Middleware.BaseUrl, "https://api.wassi.chat/v1"

  plug Tesla.Middleware.Headers, [
    {"token", "f72b338f2ee531332e95824c0c8e74c6a0b60da4b2f521f82c3fb42b6815a444d33d4ec2a52c056f"}
  ]

  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.JSON

  @device "61683609a25fda1c540fa654"

  def send(to, message) when is_bitstring(to) do
    {:ok, response} =
      post("/messages", %{"phone" => to, "message" => message, "device" => @device})

    body = Map.get(response, :body)

    if Map.has_key?(body, "errorCode") do
      raise("ERROR AL ENVIAR WHATSAPP. RAZON: #{body["message"]}")
    end

    send_status = Map.take(body, ["deliveryStatus", "status", "webhookStatus"])

    %{"STATUS_ENVIO_WHATSAPP" => send_status}
  end

  def send_test(code, phone, message) do
    post("/whatsapp/sendmessage", %{"code" => code, "phone" => phone, "message" => message})
  end
end
