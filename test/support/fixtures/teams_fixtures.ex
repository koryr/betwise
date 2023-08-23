defmodule Betwise.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        team_name: "some team_name"
      })
      |> Betwise.Teams.create_team()

    team
  end
end
