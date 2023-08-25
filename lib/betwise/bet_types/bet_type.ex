defmodule Betwise.BetTypes.BetType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bet_types" do
    field :bet_type_name, :string
    has_many(:selections, Betwise.Selections.Selection)

    timestamps()
  end

  @doc false
  def changeset(bet_type, attrs) do
    bet_type
    |> cast(attrs, [:bet_type_name])
    |> validate_required([:bet_type_name])
  end
end
