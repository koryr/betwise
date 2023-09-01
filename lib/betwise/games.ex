defmodule Betwise.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Betwise.Emails
  alias Swoosh.Email
  alias Betwise.Invoices
  alias Betwise.Bets
  alias Betwise.Selections
  alias Betwise.Repo

  alias Betwise.Games.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
    |> Repo.preload([:sport_type, :home_team, :away_team, markets: [bet_type: [:selections]]])
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id),
    do:
      Repo.get!(Game, id)
      |> Repo.preload([:sport_type, :home_team, :away_team, markets: [bet_type: [:selections]]])

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, game} ->
        game =
          game
          |> Repo.preload([:sport_type, :home_team, :away_team, :markets])

        {:ok, game}
    end

    # |> Repo.preload([:sport_type, :home_team, :away_team, markets: [bet_type: [:selections]]])
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def get_games(_datecreated) do
    query =
      from g in Game,
        where:
          is_nil(g.full_time) or
            (g.full_time == false and
               g.date_from == ^Date.utc_today() and
               g.time_from >= ^Time.utc_now()),
        select: g

    Repo.all(query)
  end

  def update_result(game, attrs \\ %{}) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, game} ->
        selection =
          cond do
            game.home > game.away ->
              "Home"

            game.home < game.away ->
              "Away"

            game.home == game.away ->
              "Draw"
          end
          |> Selections.get_selections_by_name!()

        case Bets.get_bets_by_game_id(game.id) do
          [_ | _] = bets ->
            for bet <- bets do
              Bets.update_bet_results(bet, %{status: bet.selection_id == selection.id})
            end

          [] ->
            IO.inspect("Bet not found")
        end

        Enum.map(Invoices.get_invoices(), fn invoice ->
          bet_status =
            for bet <- Bets.get_bets_by_game_id_and_invoice_id(game.id, invoice.id) do
              bet.status
            end

          case bet_status do
            [_ | _] = status ->
              result = Enum.all?(status, fn x -> x == true end)
              Invoices.update_invoice(invoice, %{status: result, complete: true})

              resp =
                cond do
                  result == true -> "Congrats You Won Jackpot"
                  result == false -> "You Lost your bet"
                end

              Emails.create_email(%{
                email_from: "haron.korir@gmail.com",
                recipient: invoice.user.email,
                subject: "Bet Results",
                content: resp,
                user_id: invoice.user.id
              })

            [] ->
              IO.inspect("No invoice found")
          end
        end)
    end
  end
end
