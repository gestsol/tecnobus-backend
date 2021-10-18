defmodule Tecnobus.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Tecnobus.Repo

  alias Tecnobus.Events.AlertType

  @doc """
  Returns the list of alert_types.

  ## Examples

      iex> list_alert_types()
      [%AlertType{}, ...]

  """
  def list_alert_types do
    Repo.all(AlertType)
  end

  @doc """
  Gets a single alert_type.

  Raises `Ecto.NoResultsError` if the Alert type does not exist.

  ## Examples

      iex> get_alert_type!(123)
      %AlertType{}

      iex> get_alert_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alert_type!(id), do: Repo.get!(AlertType, id)

  @doc """
  Creates a alert_type.

  ## Examples

      iex> create_alert_type(%{field: value})
      {:ok, %AlertType{}}

      iex> create_alert_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alert_type(attrs \\ %{}) do
    %AlertType{}
    |> AlertType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alert_type.

  ## Examples

      iex> update_alert_type(alert_type, %{field: new_value})
      {:ok, %AlertType{}}

      iex> update_alert_type(alert_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alert_type(%AlertType{} = alert_type, attrs) do
    alert_type
    |> AlertType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a alert_type.

  ## Examples

      iex> delete_alert_type(alert_type)
      {:ok, %AlertType{}}

      iex> delete_alert_type(alert_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alert_type(%AlertType{} = alert_type) do
    Repo.delete(alert_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alert_type changes.

  ## Examples

      iex> change_alert_type(alert_type)
      %Ecto.Changeset{data: %AlertType{}}

  """
  def change_alert_type(%AlertType{} = alert_type, attrs \\ %{}) do
    AlertType.changeset(alert_type, attrs)
  end

  alias Tecnobus.Events.Alert

  @doc """
  Returns the list of alerts.

  ## Examples

      iex> list_alerts()
      [%Alert{}, ...]

  """
  def list_alerts do
    Repo.all(Alert)
    |> Repo.preload(:alert_type)
  end

  @doc """
  Gets a single alert.

  Raises `Ecto.NoResultsError` if the Alert does not exist.

  ## Examples

      iex> get_alert!(123)
      %Alert{}

      iex> get_alert!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alert!(id), do: Repo.get!(Alert, id) |> Repo.preload(:alert_type)

  @doc """
  Creates a alert.

  ## Examples

      iex> create_alert(%{field: value})
      {:ok, %Alert{}}

      iex> create_alert(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alert(attrs \\ %{}) do
    %Alert{}
    |> Alert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alert.

  ## Examples

      iex> update_alert(alert, %{field: new_value})
      {:ok, %Alert{}}

      iex> update_alert(alert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alert(%Alert{} = alert, attrs) do
    alert
    |> Alert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a alert.

  ## Examples

      iex> delete_alert(alert)
      {:ok, %Alert{}}

      iex> delete_alert(alert)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alert(%Alert{} = alert) do
    Repo.delete(alert)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alert changes.

  ## Examples

      iex> change_alert(alert)
      %Ecto.Changeset{data: %Alert{}}

  """
  def change_alert(%Alert{} = alert, attrs \\ %{}) do
    Alert.changeset(alert, attrs)
  end
end
