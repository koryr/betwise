defmodule Betwise.Bets.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :status, :boolean
    field :odds, :decimal
    belongs_to(:game, Betwise.Games.Game)
    belongs_to(:bet_type, Betwise.BetTypes.BetType)
    belongs_to(:selection, Betwise.Selections.Selection)
    belongs_to(:user, Betwise.Accounts.User)
    belongs_to(:invoice, Betwise.Invoices.Invoice)

    timestamps()
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:odds, :status, :game_id, :selection_id, :user_id, :invoice_id])
    |> validate_required([:odds, :game_id, :user_id])
  end
end
