defmodule Tecnobus.Events.AlertType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "alert_types" do
    field :code, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(alert_type, attrs) do
    alert_type
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
    |> unique_constraint(:code)
  end
end
