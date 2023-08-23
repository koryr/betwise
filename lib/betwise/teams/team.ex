defmodule Betwise.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :team_name, :string
    belongs_to(:sport_type, Betwise.Sports.SportType)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:team_name])
    |> validate_required([:team_name])
  end
end
