defmodule Betwise.SportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.Sports` context.
  """

  @doc """
  Generate a sport_type.
  """
  def sport_type_fixture(attrs \\ %{}) do
    {:ok, sport_type} =
      attrs
      |> Enum.into(%{
        sport_name: "some sport_name"
      })
      |> Betwise.Sports.create_sport_type()

    sport_type
  end
end
