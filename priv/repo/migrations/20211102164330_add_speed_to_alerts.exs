defmodule Tecnobus.Repo.Migrations.AddSpeedToAlerts do
  use Ecto.Migration

  def change do
    alter table(:alerts) do
      add :speed, :integer
    end
  end
end
