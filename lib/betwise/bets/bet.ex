defmodule Betwise.Bets.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :bet_amount, :decimal
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
    |> cast(attrs, [:odds, :bet_amount, :game_id, :selection_id, :bet_type_id, :invoice_id])
    |> validate_required([:odds, :bet_amount])
  end
end
