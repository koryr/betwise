defmodule Betwise.Markets.Market do
  use Ecto.Schema
  import Ecto.Changeset

  schema "markets" do
    field :odds, :map
    belongs_to(:game, Betwise.Games.Game)
    belongs_to(:bet_type, Betwise.BetTypes.BetType)
    belongs_to(:user, Betwise.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(market, attrs) do
    market
    |> cast(attrs, [:odds,:game, :bet_type, :user])
    |> validate_required([:odds])
  end
end
