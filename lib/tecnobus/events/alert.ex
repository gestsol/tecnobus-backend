defmodule Tecnobus.Events.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  schema "alerts" do
    field :datetime, :naive_datetime
    field :device, :string
    field :group, :string
    field :lat, :string
    field :lng, :string

    belongs_to :alert_type, Tecnobus.Events.AlertType

    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:device, :datetime, :lat, :lng, :group, :alert_type_id])
    |> validate_required([:device, :datetime, :lat, :lng, :group, :alert_type_id])
  end
end
