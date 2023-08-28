defmodule Betwise.Bets do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Betwise.Repo
  alias Betwise.Bets.Bet

  def list_bets() do
    Repo.all(Bet)
    |> Repo.preload([:user, :selection, game: [:home_team, :away_team]])
  end

  def create_bet(attrs \\ %{}) do
    %Bet{}
    |> Bet.changeset(attrs)
    |> Repo.insert()
  end

  def change_bet(%Bet{} = bet, attrs \\ %{}) do
    Bet.changeset(bet, attrs)
  end
end
