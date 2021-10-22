defmodule Tecnobus.API.Whatsapp do

  use Tesla, only: [:post, :get]

  plug Tesla.Middleware.BaseUrl, "https://api.wassi.chat/v1"
  plug Tesla.Middleware.Headers, [{"token", "f72b338f2ee531332e95824c0c8e74c6a0b60da4b2f521f82c3fb42b6815a444d33d4ec2a52c056f"}]
  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.JSON

  @device "61683609a25fda1c540fa654"

  def send(to, message) when is_bitstring(to) do
    post("/messages", %{"phone" => to, "message" => message, "device" => @device})
  end
end
