defmodule Betwise.Repo.Migrations.CreateSelections do
  use Ecto.Migration

  def change do
    create table(:selections) do
      add :name, :string
      add :bet_type_id, references(:bet_types, on_delete: :nothing)

      timestamps()
    end

    create index(:selections, [:bet_type_id])
    create unique_index(:selections, [:bet_type_id, :name])
  end
end
