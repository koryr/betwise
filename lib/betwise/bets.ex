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

  def get_bet!(id),
    do:
      Repo.get!(Bet, id)
      |> Repo.preload([:user, :selection, game: [:home_team, :away_team]])

  def create_bet(attrs \\ %{}) do
    %Bet{}
    |> Bet.changeset(attrs)
    |> Repo.insert()
  end

  def change_bet(%Bet{} = bet, attrs \\ %{}) do
    Bet.changeset(bet, attrs)
  end

  def get_bets_by_game_id(game_id) do
    query =
      from b in Bet,
        where: b.game_id == ^game_id,
        select: b

    Repo.all(query)
  end

  def get_bets_by_game_id_and_invoice_id(game_id, invoice_id) do
    query =
      from b in Bet,
        where: b.game_id == ^game_id and b.invoice_id == ^invoice_id,
        select: b

    Repo.all(query)
  end

  def update_bet_results(bet, attrs) do
    bet
    |> Bet.changeset(attrs)
    |> Repo.update()
  end

  def list_bets(user_id) do
    query =
      from b in Bet,
        where: b.user_id == ^user_id,
        select: b

    Repo.all(query)
    |> Repo.preload([:user, :selection, game: [:home_team, :away_team]])
  end

  def cancel_bet(id, attrs) do
    get_bet!(id)
    |> Bet.changeset(attrs)
    |> Repo.update()
  end
end
