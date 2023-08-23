defmodule Betwise.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        date_from: ~D[2023-08-22],
        date_to: ~D[2023-08-22],
        time_from: ~T[14:00:00],
        time_to: ~T[14:00:00]
      })
      |> Betwise.Games.create_game()

    game
  end
end
