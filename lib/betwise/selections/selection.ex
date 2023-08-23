defmodule Betwise.Selections.Selection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "selections" do
    field :name, :string
    belongs_to(:bet_type, Betwise.BetTypes.BetType)

    timestamps()
  end

  @doc false
  def changeset(selection, attrs) do
    selection
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
