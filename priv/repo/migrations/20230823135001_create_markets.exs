defmodule Betwise.Repo.Migrations.CreateMarkets do
  use Ecto.Migration

  def change do
    create table(:markets) do
      add :odds, :map
      add :game_id, references(:games, on_delete: :nothing)
      add :bet_type_id, references(:bet_types, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:markets, [:game_id])
    create index(:markets, [:bet_type_id])
    create index(:markets, [:user_id])
  end
end
