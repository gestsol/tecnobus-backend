defmodule Tecnobus.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    create table(:alerts) do
      add :device, :string
      add :datetime, :naive_datetime
      add :lat, :string
      add :lng, :string
      add :group, :string
      add :alert_type_id, references(:alert_types, on_delete: :nothing)

      timestamps()
    end

    create index(:alerts, [:alert_type_id])
  end
end
