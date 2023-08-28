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

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(market, attrs) do
    market
    |> cast(attrs, [:odds,:game_id, :bet_type_id, :user_id])
    |> validate_required([:odds])
    |> unique_constraint([:game_id, :bet_type_id])
  end
end
