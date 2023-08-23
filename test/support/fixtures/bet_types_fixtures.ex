defmodule Betwise.BetTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.BetTypes` context.
  """

  @doc """
  Generate a bet_type.
  """
  def bet_type_fixture(attrs \\ %{}) do
    {:ok, bet_type} =
      attrs
      |> Enum.into(%{
        bet_type_name: "some bet_type_name"
      })
      |> Betwise.BetTypes.create_bet_type()

    bet_type
  end
end
