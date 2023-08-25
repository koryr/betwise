defmodule Betwise.BetTypes do
  @moduledoc """
  The BetTypes context.
  """

  import Ecto.Query, warn: false
  alias Betwise.Repo

  alias Betwise.BetTypes.BetType

  @doc """
  Returns the list of bet_types.

  ## Examples

      iex> list_bet_types()
      [%BetType{}, ...]

  """
  def list_bet_types do
    Repo.all(BetType)|>Repo.preload(selections: [:bet_type])
  end

  @doc """
  Gets a single bet_type.

  Raises `Ecto.NoResultsError` if the Bet type does not exist.

  ## Examples

      iex> get_bet_type!(123)
      %BetType{}

      iex> get_bet_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bet_type!(id), do: Repo.get!(BetType, id)

  @doc """
  Creates a bet_type.

  ## Examples

      iex> create_bet_type(%{field: value})
      {:ok, %BetType{}}

      iex> create_bet_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bet_type(attrs \\ %{}) do
    %BetType{}
    |> BetType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bet_type.

  ## Examples

      iex> update_bet_type(bet_type, %{field: new_value})
      {:ok, %BetType{}}

      iex> update_bet_type(bet_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bet_type(%BetType{} = bet_type, attrs) do
    bet_type
    |> BetType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bet_type.

  ## Examples

      iex> delete_bet_type(bet_type)
      {:ok, %BetType{}}

      iex> delete_bet_type(bet_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bet_type(%BetType{} = bet_type) do
    Repo.delete(bet_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bet_type changes.

  ## Examples

      iex> change_bet_type(bet_type)
      %Ecto.Changeset{data: %BetType{}}

  """
  def change_bet_type(%BetType{} = bet_type, attrs \\ %{}) do
    BetType.changeset(bet_type, attrs)
  end
end
