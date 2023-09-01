defmodule Betwise.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :team_name, :string
      add :sport_type_id, references(:sport_types, on_delete: :nothing)

      timestamps()
    end

    create index(:teams, [:sport_type_id])
    create unique_index(:teams, [:sport_type_id, :team_name])
  end
end
