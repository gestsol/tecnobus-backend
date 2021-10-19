defmodule Tecnobus.API.Whatsapp do

  use Tesla, only: [:post, :get]

  plug Tesla.Middleware.Timeout, timeout: 120_000
  plug Tesla.Middleware.BaseUrl, "https://message-backend.gestsol.io"
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.JSON

  def send(code, phone, message) do
    {:ok, response} = post(
      "/whatsapp/sendmessage",
      %{ code: code, phone: phone, message: message },
      opts: [adapter: [recv_timeout: 120_000]]
    )

    Map.get(response, :body) |> IO.inspect()
  end
end
