defmodule Betwise.Sports do
  @moduledoc """
  The Sports context.
  """

  import Ecto.Query, warn: false
  alias Betwise.Repo

  alias Betwise.Sports.SportType

  @doc """
  Returns the list of sport_type.

  ## Examples

      iex> list_sport_type()
      [%SportType{}, ...]

  """
  def list_sport_type do
    Repo.all(SportType)
  end

  @doc """
  Gets a single sport_type.

  Raises `Ecto.NoResultsError` if the Sport type does not exist.

  ## Examples

      iex> get_sport_type!(123)
      %SportType{}

      iex> get_sport_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sport_type!(id), do: Repo.get!(SportType, id)

  @doc """
  Creates a sport_type.

  ## Examples

      iex> create_sport_type(%{field: value})
      {:ok, %SportType{}}

      iex> create_sport_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sport_type(attrs \\ %{}) do
    %SportType{}
    |> SportType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sport_type.

  ## Examples

      iex> update_sport_type(sport_type, %{field: new_value})
      {:ok, %SportType{}}

      iex> update_sport_type(sport_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sport_type(%SportType{} = sport_type, attrs) do
    sport_type
    |> SportType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sport_type.

  ## Examples

      iex> delete_sport_type(sport_type)
      {:ok, %SportType{}}

      iex> delete_sport_type(sport_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sport_type(%SportType{} = sport_type) do
    Repo.delete(sport_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sport_type changes.

  ## Examples

      iex> change_sport_type(sport_type)
      %Ecto.Changeset{data: %SportType{}}

  """
  def change_sport_type(%SportType{} = sport_type, attrs \\ %{}) do
    SportType.changeset(sport_type, attrs)
  end
end
