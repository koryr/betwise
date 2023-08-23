defmodule Betwise.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :date_from, :date
    field :date_to, :date
    field :time_from, :time
    field :time_to, :time
    belongs_to(:sport_type, Betwise.Sports.SportType)
    belongs_to(:home_team, Betwise.Teams.Team)
    belongs_to(:away_team, Betwise.Teams.Team)

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:date_from, :time_from, :date_to, :time_to])
    |> validate_required([:date_from, :time_from, :date_to, :time_to])
  end
end
