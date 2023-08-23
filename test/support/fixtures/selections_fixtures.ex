defmodule Betwise.SelectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.Selections` context.
  """

  @doc """
  Generate a selection.
  """
  def selection_fixture(attrs \\ %{}) do
    {:ok, selection} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Betwise.Selections.create_selection()

    selection
  end
end
