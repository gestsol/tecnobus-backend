defmodule Tecnobus.Repo do
  use Ecto.Repo,
    otp_app: :tecnobus,
    adapter: Ecto.Adapters.Postgres
end
