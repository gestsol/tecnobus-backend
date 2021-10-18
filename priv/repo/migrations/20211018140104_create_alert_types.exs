defmodule Tecnobus.Repo.Migrations.CreateAlertTypes do
  use Ecto.Migration

  def change do
    create table(:alert_types) do
      add :name, :string
      add :code, :string

      timestamps()
    end

  end
end
