defmodule Betwise.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :date_from, :date
      add :time_from, :time
      add :date_to, :date
      add :time_to, :time
      add :sport_type_id, references(:sport_types, on_delete: :nothing)
      add :home_team_id, references(:teams, on_delete: :nothing)
      add :away_team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end
    create index(:games, [:sport_type_id])
    create index(:games, [:home_team_id])
    create index(:games, [:away_team_id])
  end
end
