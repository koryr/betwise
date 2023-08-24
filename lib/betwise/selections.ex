defmodule Betwise.Selections do
  @moduledoc """
  The Selections context.
  """

  import Ecto.Query, warn: false
  alias Betwise.Repo

  alias Betwise.Selections.Selection

  @doc """
  Returns the list of selections.

  ## Examples

      iex> list_selections()
      [%Selection{}, ...]

  """
  def list_selections do
    Repo.all(Selection)
    |>Repo.preload([:bet_type])
  end

  @doc """
  Gets a single selection.

  Raises `Ecto.NoResultsError` if the Selection does not exist.

  ## Examples

      iex> get_selection!(123)
      %Selection{}

      iex> get_selection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_selection!(id), do: Repo.get!(Selection, id)

  @doc """
  Creates a selection.

  ## Examples

      iex> create_selection(%{field: value})
      {:ok, %Selection{}}

      iex> create_selection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_selection(attrs \\ %{}) do
    %Selection{}
    |> Selection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a selection.

  ## Examples

      iex> update_selection(selection, %{field: new_value})
      {:ok, %Selection{}}

      iex> update_selection(selection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_selection(%Selection{} = selection, attrs) do
    selection
    |> Selection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a selection.

  ## Examples

      iex> delete_selection(selection)
      {:ok, %Selection{}}

      iex> delete_selection(selection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_selection(%Selection{} = selection) do
    Repo.delete(selection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking selection changes.

  ## Examples

      iex> change_selection(selection)
      %Ecto.Changeset{data: %Selection{}}

  """
  def change_selection(%Selection{} = selection, attrs \\ %{}) do
    Selection.changeset(selection, attrs)
  end

  @doc """
  get select by bet type
  """

  def get_selections_by_bet_type!(id) do
    from(s in Selection, where: [bet_type_id: ^id], order_by: [asc: :id])
    |> Repo.all()

  end
end
