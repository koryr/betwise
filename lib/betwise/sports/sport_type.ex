defmodule Betwise.Sports.SportType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sport_types" do
    field :sport_name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(sport_type, attrs) do
    sport_type
    |> cast(attrs, [:sport_name, :description])
    |> validate_required([:sport_name])
  end
end
