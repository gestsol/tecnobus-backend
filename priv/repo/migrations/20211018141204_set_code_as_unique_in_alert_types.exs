defmodule Tecnobus.Repo.Migrations.SetCodeAsUniqueInAlertTypes do
  use Ecto.Migration

  def change do
    create unique_index(:alert_types, [:code])
  end
end
